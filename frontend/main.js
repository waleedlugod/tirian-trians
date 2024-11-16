function buttontest() {
  fetch('/api/test')
    .then(res => res.json())
    .then((data) => {
      const template = document.createElement('template')
      template.innerHTML = `<p>${data.test}</p>`
      document.body.appendChild(template.content)
    })
}

function dbtest() {
  fetch('/api/db_test')
    .then(res => res.json())
    .then((res) => {
      const data = res[0]
      const template = document.createElement('template')
      template.innerHTML = `
        <p>id: ${data.id}</p>
        <p>name: ${data.name}</p>
      `
      document.body.appendChild(template.content)
    })
}
