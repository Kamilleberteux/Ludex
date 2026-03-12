// app/javascript/controllers/read_more_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "button"]

  connect() {
    // Si la hauteur réelle (scrollHeight) est égale à la hauteur affichée (clientHeight),
    // alors le texte est court, on cache le bouton.
    if (this.contentTarget.scrollHeight <= this.contentTarget.clientHeight) {
      this.buttonTarget.style.display = "none"
    }
  }

  toggle(event) {
    event.preventDefault() // Empêche le lien de sauter
    this.contentTarget.classList.toggle("line-clamp-none")
    this.buttonTarget.textContent = this.contentTarget.classList.contains("line-clamp-none")
      ? "Lire moins"
      : "Lire la suite..."
  }
}
