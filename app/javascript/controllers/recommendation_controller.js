import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step"]

  connect() {
    this.currentStep = 0
    this.updateDisplay(false)
  }

  back() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.updateDisplay(false)
    }
  }

  answer(event) {
    const button = event.currentTarget
    const name = button.dataset.name
    const value = button.dataset.value

    const input = this.element.querySelector(`input[name="${name}"]`)
    if (input) input.value = value

    button.closest("[data-recommendation-target='step']")
          .querySelectorAll("button")
          .forEach(btn => btn.classList.remove("active"))
    button.classList.add("active")

    this.currentStep++

    if (this.currentStep >= this.stepTargets.length) {
      setTimeout(() => this.element.submit(), 200)
    } else {
      setTimeout(() => this.updateDisplay(true), 200)
    }
  }

  updateDisplay(animate = true) {
    this.stepTargets.forEach((step, i) => {
      if (i === this.currentStep) {
        step.hidden = false
        if (animate) {
          step.classList.add("reco-step--entering")
          setTimeout(() => step.classList.remove("reco-step--entering"), 350)
        }
      } else {
        step.hidden = true
      }
    })
  }
}
