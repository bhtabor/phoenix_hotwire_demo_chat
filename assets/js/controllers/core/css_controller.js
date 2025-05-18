import { Controller } from "../../../vendor/stimulus"

export default class extends Controller {
  static classes = ["toggle"]

  static targets = ["togglable"]

  toggle() {
    for (const target of this.togglableTargets) {
      this._toggleTargetClasses(target)
    }
  }

  _toggleTargetClasses(target) {
    for (const toggleClass of this.toggleClasses) {
      target.classList.toggle(toggleClass)
    }
  }
}
