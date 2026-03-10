import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.classList.toggle("dropdown__menu--open")
  }

  close() {
    this.menuTarget.classList.remove("dropdown__menu--open")
  }
}
