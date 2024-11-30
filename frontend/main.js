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
  const id = document.getElementById("maintenance_id").value
  const cd = document.getElementById("cond").value
  const dt = document.getElementById("date").value

  filters = {cond: cd, maintenance_id: id, log_date: dt}
  for (let key of Object.keys(filters)) {
    if (filters[key] === '')
      delete filters[key];
  }

  const queryParams = new URLSearchParams(filters).toString();

  fetch(`/api/logs?${queryParams}`)
    .then(res => res.json())
    .then((res) =>{
      // will fix the formatting of this later
      const logTable = document.createElement('ul')
      for (const maintenanceLog of res){ 
        const logElement = document.createElement('li')
        logElement.append('Maintenance id: ' + maintenanceLog['maintenance_id'])
        const logCols = document.createElement('ul')
        logElement.append(logCols)
        for (const col in maintenanceLog){
          if (col == 'maintenance_id') continue
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