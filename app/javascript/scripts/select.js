import TomSelect from 'tom-select/dist/js/tom-select.popular'
import Translations from './i18n/select.json'

// из body "document.querySelector('body').dataset.lang" мы вытащим текущий язык
// из аттрибута data и подгрузим переводы для нужного языка
document.addEventListener("turbolinks:load", function() {
    const i18n = Translations[document.querySelector('body').dataset.lang]

    document.querySelectorAll('.js-multiple-select').forEach((element) => {
        let opts = {
                // подключаем плагины для удаления элементов и для удобства работы с backspace
                plugins: {
                    'remove_button': {
                        title: i18n['remove_button']
                    },
                    'no_backspace_delete': {},
                    'restore_on_backspace': {}
                },
                // в качестве значения - id тегов, в качестве отображения и для поиска - title
                valueField: 'id',
                labelField: 'title',
                searchField: 'title',
                // если тега нет, то создать его не получится
                create: false,
                // load функции, которая принимает запрос и callback (term - это то, что написал юзер)
                load: function(query, callback) {
                    const url = element.dataset.ajaxUrl + '.json?term=' + encodeURIComponent(query)

                    fetch(url)
                        // получаем ответ от сервера
                        .then(response => response.json())
                        .then(json => {
                            callback(json)
                        }).catch(() => {
                            callback()
                        })
                },
                // если ничего не нашлось, то будет разметка '<div class="no-results">' с текстом
                // i18n['no_results']
                render: {
                    no_results: function(_data, _escape) {
                        return '<div class="no-results">' + i18n['no_results'] + '</div>';
                    }
                }
            }
            // создаем новый элемент TomSelect
        new TomSelect(element, opts)
    })
})