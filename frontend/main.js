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

function getMaintenanceLog() {
  const form = document.getElementById('maintenance-log-filter');
  const formData = new FormData(form);

  const filters = {}
  for (let [key, value] of formData.entries()) {
    if (value !== '') {
      filters[key] = value
    }
  }
  console.log(filters)

  const queryParams = new URLSearchParams(filters).toString();

  fetch(`/api/logs?${queryParams}`)
    .then(res => res.json())
    .then((res) =>{
      // will fix the formatting of this later
      app.innerHTML=''
      const logTable = document.createElement('ul')
      for (const maintenanceLog of res){
        const logElement = document.createElement('li')
        logElement.append('Maintenance Log #: ' + maintenanceLog['Maintenance ID'])
        const logCols = document.createElement('ul')
        logElement.append(logCols)
        for (const col in maintenanceLog){
          if (col == 'Maintenance ID') continue
          const logCol = document.createElement('li')
          const elem = col + ': ' + maintenanceLog[col]
          logCol.append(elem)
          logCols.append(logCol)
        }
        logTable.append(logElement)
      }
      app.append(logTable)
    })
}