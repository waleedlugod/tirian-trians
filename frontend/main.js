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
      const app = document.getElementById("maintenance");
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

function getStations() {
  fetch('/api/stations')
    .then(res => res.json())
    .then((res) => {
      console.log(res);
      const app = document.getElementById("station");
      app.innerHTML = '';

      const stationTable = document.createElement('ul');
      
      for (const station of res) {
        const stationElement = document.createElement('li');
        
        const stationCols = document.createElement('ul');
        stationElement.append(stationCols);

        for (const col in station) {
          
          const stationCol = document.createElement('li');
          const elem = `${col}: ${station[col]}`;
          stationCol.append(elem);
          stationCols.append(stationCol);
        }

        stationTable.append(stationElement);
      }

      app.append(stationTable);
    });
}