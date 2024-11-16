Before running anything, install the packages with `npm i`.

To create and run a local server, type `npm run dev`, and open (localhost:8080)[localhost:8080] in your browser.

# Database setup
1. Create a `.env` file and copy the contents of `.env.example`. Edit the file if necessary but defaults should be fine.
    * If you get an error code of `ER_ACCESS_DENIED_NO_PASSWORD_ERROR`, run this (https://stackoverflow.com/a/46908573)[command].
2. Run the `backend/setup.sql` script in the mysql/mariadb terminal.
