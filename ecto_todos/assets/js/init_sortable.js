import Sortable from "sortablejs"

export const InitSortable = {
  mounted() {
    const callback = list => {
      this.pushEventTo(this.el.dataset.targetId, "sort", { list: list })
    }

    init(this.el, callback)
  }
}

const init = (sortableList, callback) => {
  const sortable = new Sortable(sortableList, {
    onSort: evt => {
      const nodeList = sortableList.querySelectorAll("[data-sortable-id]")
      let ids = []

      nodeList.forEach((element, index) => {
        const idObject = {
          id: nodeList[index].dataset.sortableId,
          position: index
        }

        ids.push(idObject)
      })

      callback(ids)
    }
  })
}
