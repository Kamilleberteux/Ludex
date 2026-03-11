// app/javascript/controllers/swiper_controller.js
import { Controller } from "@hotwired/stimulus"
import Swiper from "swiper" // C'est cette ligne qui lie ton importmap au code

export default class extends Controller {
 connect() {
  const slidesCount = this.element.querySelectorAll('.swiper-slide').length;

  this.swiper = new Swiper(this.element, {
    pagination: {
      el: this.element.querySelector('.swiper-pagination'),
      clickable: true,
    },
    // On n'active le loop que si on a au moins 3 slides
    loop: slidesCount >= 3,
  })
}

  disconnect() {
    if (this.swiper) this.swiper.destroy()
  }
}
