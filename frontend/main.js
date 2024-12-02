function getStations() {
  fetch('/api/stations')
    .then(res => res.json())
    .then((res) => {
      console.log(res);
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