import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle() {
    this.panelTarget.classList.toggle("filters-panel--open")
  }

  submit() {
    this.element.closest("form").requestSubmit()
  }
}
