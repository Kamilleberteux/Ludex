import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "addBtn"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.classList.toggle("dropdown__menu--open")
  }

  close() {
    this.menuTarget.classList.remove("dropdown__menu--open")
  }

  handleAdd(event) {
    event.preventDefault()

    const btn = this.addBtnTarget
    btn.innerHTML = '<i class="fa-solid fa-check"></i>'
    this.close()

    fetch(event.target.action, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      }
    })

    setTimeout(() => {
      btn.textContent = "+"
    }, 3000)
  }
}
