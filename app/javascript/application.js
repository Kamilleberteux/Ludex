// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "swiper/swiper-bundle.css" // Si ton environnement le supporte
import Swiper from "swiper"
window.Swiper = Swiper // Permet d'y accéder partout
