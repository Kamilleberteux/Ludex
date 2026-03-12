import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "suggestions"]

  connect() {
    this.inputTarget.addEventListener("input", () => this.onInput())
  }

  async onInput() {
    const query = this.inputTarget.value.trim()

    if (query.length < 3) {
      this.suggestionsTarget.innerHTML = ""
      return
    }

    const response = await fetch(
      `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(query)}&format=json&addressdetails=1&limit=5&featuretype=city`
    )
    const data = await response.json()

    this.suggestionsTarget.innerHTML = ""
    data.forEach(place => {
      const li = document.createElement("li")
      const city = place.address.city || place.address.town || place.address.village || place.address.municipality || ""
      const country = place.address.country || ""
      li.textContent = `${city}, ${country}`
      li.classList.add("autocomplete-item")
      li.addEventListener("click", () => {
        this.inputTarget.value = `${city}, ${country}`
        this.suggestionsTarget.innerHTML = ""
      })
      this.suggestionsTarget.appendChild(li)
    })
  }
}
