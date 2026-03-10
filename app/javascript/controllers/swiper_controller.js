import { Controller } from "@hotwired/stimulus"

// Connecte-toi à Swiper (assure-toi qu'il soit importé dans ton application.js)
export default class extends Controller {
  connect() {
    this.swiper = new Swiper(this.element, {
      pagination: {
        el: '.swiper-pagination',
        clickable: true,
      },
      loop: true,
    })
  }

  // C'est important pour éviter les fuites de mémoire
  // quand Turbo remplace le contenu de la page
  disconnect() {
    if (this.swiper) {
      this.swiper.destroy()
    }
  }
}
