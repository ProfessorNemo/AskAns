// This is a manifest file that'll be compiled into application.js, which will
// include all the files listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts,
// vendor/assets/javascripts, or any plugin's vendor/assets/javascripts
// directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear
// at the bottom of the compiled file.
//
// Read Sprockets README for details about supported directives.
//
// https://github.com/rails/sprockets#sprockets-directives
//
//= require jquery
//= require jquery_ujs
//= require_tree .

document.addEventListener('DOMContentLoaded', () => {
    const askButton = document.getElementById('ask-button')
    const askForm = document.getElementById('ask-form')

    window.onresize = () => {
        askForm.style.display = window.innerWidth < 960 ? 'none' : 'block'
    }

    askButton.addEventListener('click', (event) => {
        event.preventDefault()

        setTimeout(() => {
            const displayStyle = askForm.style.display === 'block' ? 'none' : 'block'
            askForm.style.display = displayStyle
        }, 300)
    })
})