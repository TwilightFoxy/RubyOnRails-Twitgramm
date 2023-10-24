// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails" Отключено потому что иначе не рабоают якоря
import "controllers"
import "./comments"
import "posts"
//= require rails-ujs

function setTheme(themeName) {
    document.body.className = themeName;
    localStorage.setItem('theme', themeName);
}

window.onload = function() {
    if (localStorage.getItem('theme')) {
        setTheme(localStorage.getItem('theme'));
    }
}

document.addEventListener("turbolinks:load", function() {
    if (window.history && window.history.pushState) {
        $(window).on('popstate', function(event) {
            var anchorLocation = window.location.hash;
            if(anchorLocation) {
                window.scrollTo(0, $(anchorLocation).offset().top);
            }
        });
    }
});

document.getElementById('file-upload').addEventListener('change', function() {
    var statusElem = document.getElementById('file-upload-status');
    var previewImage = document.getElementById('file-preview-image');
    var fileNameElem = document.getElementById('file-name');

    if (this.files.length > 0) {
        var file = this.files[0];
        var reader = new FileReader();

        reader.onload = function(e) {
            previewImage.src = e.target.result;
            previewImage.style.display = 'block';
        }
        reader.readAsDataURL(file);

        fileNameElem.textContent = file.name;
        statusElem.textContent = 'Загружено!';
    } else {
        previewImage.style.display = 'none';  // скрыть изображение, если файл был удален
        fileNameElem.textContent = '';
        statusElem.textContent = '';
    }
});
