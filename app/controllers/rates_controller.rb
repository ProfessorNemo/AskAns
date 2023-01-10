# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    @current_rate = if yaml_service.get(:is_force)
                      yaml_service.get(:force_rate)
                    else
                      yaml_service.get(:current_rate)
                    end
  end

  def currency
    @force_rate = yaml_service.get(:force_rate)
    @force_end_datetime = yaml_service.get(:force_end_datetime)
    @is_force = yaml_service.get(:is_force)

    flash[:notice] = nil

    return unless @is_force

    flash.now[:notice] =
      "Форсированное значение курса установлено на #{@force_rate} до #{DateTime.parse(@force_end_datetime).strftime('%d.%m.%Y %H:%M')}"
  end

  def force_rate
    unless validate_params
      yaml_service.put(:force_rate, Float(params[:force_rate]))
      yaml_service.put(:force_end_datetime, params[:force_end_datetime])
      yaml_service.put(:is_force, true)

      force_end_datetime = DateTime.parse("#{params[:force_end_datetime]}#{Time.zone.now.formatted_offset}")
      ActionCable.server.broadcast('web_rate_update_channel', { content: params[:force_rate] })

      # Найти запланированные задания и удалить их
      # https://stackoverflow.com/questions/57859296/how-to-delete-sidekiq-scheduled-job
      ss = Sidekiq::ScheduledSet.new
      jobs = ss.scan('ForceEndWorker').select { |retri| retri.klass == 'ForceEndWorker' }
      jobs.each(&:delete)

      ForceEndWorker.perform_at(force_end_datetime, 'End force rate', 1)
    end

    redirect_to currency_path
  end

  private

  def validate_params
    if DateTime.parse("#{params[:force_end_datetime]}#{Time.zone.now.formatted_offset}") <= Time.zone.now
      flash[:alert] = 'Выбранная дата должна быть больше текущей.'
    end

    begin
      Float(params[:force_rate])
    rescue ArgumentError
      flash[:alert] = 'Значение курса должно быть числовым.'
    end

    flash[:alert].present?
  end

  def yaml_service
    @yaml_service ||= YamlService.new
  end
end
