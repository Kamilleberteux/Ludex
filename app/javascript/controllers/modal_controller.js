import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  open(event) {
    event.preventDefault()
    event.stopPropagation()
    this.overlayTarget.classList.add("modal-overlay--open")
  }

  close(event) {
    event.stopPropagation()
    this.overlayTarget.classList.remove("modal-overlay--open")
  }

  backdropClose(event) {
    if (event.target === this.overlayTarget) {
      this.overlayTarget.classList.remove("modal-overlay--open")
    }
  }
}
