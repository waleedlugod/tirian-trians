function getMaintenanceLog() {
  const form = document.getElementById("maintenance-log-filter");
  const formData = new FormData(form);

  const filters = {};
  for (let [key, value] of formData.entries()) {
    if (value !== "") {
      filters[key] = value;
    }
  }
  console.log(filters);

  const queryParams = new URLSearchParams(filters).toString();
  console.log(queryParams);
  fetch(`/api/logs?${queryParams}`)
    .then((res) => res.json())
    .then((res) => {
      const app = document.getElementById("maintenance");
      app.innerHTML = "";

      const logTable = document.createElement("ul");
			logTable.classList.add('data-query')
      for (const maintenanceLog of res) {
        const logElement = document.createElement("li");
        logElement.append(
          "Maintenance Log #: " + maintenanceLog["Maintenance ID"],
        );
        const logCols = document.createElement("ul");
        logElement.append(logCols);

        for (const col in maintenanceLog) {
          if (col == "Maintenance ID") continue;
          const logCol = document.createElement("li");
          const elem = col + ": " + maintenanceLog[col];
          logCol.append(elem);
          logCols.append(logCol);
        }
        logTable.append(logElement);
      }
      app.append(logTable);
    });
}

function getStations() {
  fetch("/api/stations")
    .then((res) => res.json())
    .then((res) => {
      const app = document.getElementById("station");
      app.innerHTML = "";

      const stationTable = document.createElement("ul");
			stationTable.classList.add('data-query')
      for (const station of res) {
        const stationElement = document.createElement("li");
        const stationCols = document.createElement("ul");
        stationElement.append(stationCols);

        for (const col in station) {
          const stationCol = document.createElement("li");
          const elem = `${col}: ${station[col]}`;
          stationCol.append(elem);
          stationCols.append(stationCol);
        }
        stationTable.append(stationElement);
      }
      app.append(stationTable);
    });
}

function getDestinationRoutes() {
  const destination = document.getElementById("station_name").value;
  const destQuery = `destination=${destination}`;

  fetch(`/api/destinationRoutes?${destQuery}`)
    .then((res) => res.json())
    .then((res) => {
      const app = document.getElementById("station");
      app.innerHTML = "";

      const routesTable = document.createElement("ul");
			routesTable.classList.add('data-query')
      for (const route of res) {
        const routeElement = document.createElement("li");
        const routeCols = document.createElement("ul");
        routeElement.append(routeCols);

        for (const col in route) {
          const routeCol = document.createElement("li");
          const elem = `${col}: ${route[col]}`;
          routeCol.append(elem);
          routeCols.append(routeCol);
        }
        routesTable.append(routeElement);
      }
      app.append(routesTable);
    });
}

function getOutgoingRoutes() {
  const origin = document.getElementById("station_name").value;
  const originQuery = `origin=${origin}`;

  fetch(`/api/outgoingRoutes?${originQuery}`)
    .then((res) => res.json())
    .then((res) => {
      const app = document.getElementById("station");
      app.innerHTML = "";

      const routesTable = document.createElement("ul");
			routesTable.classList.add('data-query')
      for (const route of res) {
        const routeElement = document.createElement("li");
        const routeCols = document.createElement("ul");
        routeElement.append(routeCols);

        for (const col in route) {
          const routeCol = document.createElement("li");
          const elem = `${col}: ${route[col]}`;
          routeCol.append(elem);
          routeCols.append(routeCol);
        }
        routesTable.append(routeElement);
      }
      app.append(routesTable);
    });
}

function getPassengerTickets() {
<<<<<<< Updated upstream
  const passengerName = document.getElementById("passenger-name").value;
=======
  const passengerName = document.getElementById('passenger-name').value;
	if (passengerName == "") {break}
>>>>>>> Stashed changes
  const passengerNameQuery = `passenger=${passengerName}`;
  console.log(passengerNameQuery);
  fetch(`/api/tickets?${passengerNameQuery}`)
    .then((res) => res.json())
    .then((res) => {
      const app = document.getElementById("tickets");
      app.innerHTML = "";

      const ticketsTable = document.createElement("ul");
			ticketsTable.classList.add('data-query')
      for (const ticket of res) {
        const ticketRow = document.createElement("li");
        const ticketCols = document.createElement("ul");
        ticketRow.append(ticketCols);

        for (const col in ticket) {
          const ticketCol = document.createElement("li");
          const elem = `${col}: ${ticket[col]}`;
          ticketCol.append(elem);
          ticketCols.append(ticketCol);
<<<<<<< Updated upstream
        }
        ticketsTable.append(ticketRow);
      }
      app.append(ticketsTable);
    });
}

function postMaintenanceLog() {
  const form = document.getElementById("maintenance-log-post");
  const fd = new FormData(form);
  const urlEncoded = new URLSearchParams(fd).toString();

  fetch("/api/logs", {
    method: "POST",
    body: urlEncoded,
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
  }).then((res) => console.log(res));
}

function updateStations() {
  fetch("/api/stations")
    .then((res) => res.json())
    .then((res) => {
      const selectEl = document.getElementById("station_name");
			selectEl.innerHTML = ""
			res.map((e, i) => {
				const option = document.createElement("option")
				if (i === 0) {
					option.setAttribute("value", "")
					option.innerText = "-- Select Destination --"
				} else {
					option.setAttribute("value", i)
					option.innerText = e["Station Name"]
				}
				selectEl.append(option)
			})
    });
}
updateStations()
=======
        } ticketsTable.append(ticketRow);
      } app.append(ticketsTable);
    })
}
>>>>>>> Stashed changes
