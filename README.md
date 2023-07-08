## Highlights

![CI Badge](https://github.com/hanjustin/AcronymsWiki/actions/workflows/main.yml/badge.svg)


<table>
  <tr>
    <td align="left"><b>Key functionalities:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
    <td><b>RESTful</b> web service + <b>CI</b></td>
  </tr>
  <tr>
    <td align="left"><b>Tech used:</b></td>
    <td align="right">Swift, Xcode, Vapor, MySQL, Docker, GitHub Actions</td>
  </tr>
</table>

### [CI workflow diagram link](https://github.com/hanjustin/CI-Tools/blob/main/README.md#github-action---workflow1-workflow2)

## Prerequisites

![Swift Version](https://img.shields.io/badge/Swift-5.7+-Green) ![Xcode](https://img.shields.io/badge/Xcode-14.2-blue)
[![Docker](https://img.shields.io/badge/Docker-FFFFFF?style=for-the-badge&logo=docker&logoColor=white.svg)]([https://shields.io/](https://www.docker.com/products/docker-desktop/))

## Getting Started

1. Clone the repo
```sh
git clone https://github.com/hanjustin/AcronymsWiki.git
```

2. Start MySQL using Docker

```sh
docker run --name mysql-vapor-db \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  -e MYSQL_DATABASE=vapor_database \
  -e MYSQL_USER=vapor_username \
  -e MYSQL_PASSWORD=vapor_password \
  mysql --default-authentication-plugin=mysql_native_password
```

3. Start Swift app by running command in the terminal

```
swift run
```

4. Use the webservice to create the first user

```
curl -X POST -H "Content-type: application/json" -d '{"name": "Justin", "username": "hanjustin"}' 'http://localhost:8080/api/users/'
```

## For local testing:
```
docker run --name mysql-testDB \
  -p 32574:3306 \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  -e MYSQL_DATABASE=vapor-test \
  -e MYSQL_USER=vapor_username \
  -e MYSQL_PASSWORD=vapor_password \
  mysql --default-authentication-plugin=mysql_native_password
```


## REST API

### Users
<table>
    <thead>
        <tr>
            <th><br></th>
            <th>Status code & Message body<br></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td valign="top"><code><b>GET</b> /api/users/</code></td>
            <td>
            <pre lang="json">
[
    {
        "name": "Justin",
        "username": "hanjustin",
        "id": "2D2D962C-728A-4381-BBDC-6838C634774E"
    }
]</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>POST</b> /api/users/</code></td>
            <td>
                <b>Request body:</b>
                <pre lang="json">
{
    "name": "Justin",
    "username": "hanjustin"
}</pre>
                <b>Response body:</b>
                <pre lang="json">
{
    "id": "2D2D962C-728A-4381-BBDC-6838C634774E",
    "name": "Justin",
    "username": "hanjustin"
}</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>GET</b> /api/users/:id</code></td>
            <td>
                <pre lang="json">
{
    "id": "2D2D962C-728A-4381-BBDC-6838C634774E",
    "name": "Justin",
    "username": "hanjustin"
}</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>GET</b> /api/users/:id/acronyms</code></td>
            <td>
                <pre lang="json">
[
    {
        "id": "C238BBFF-8276-4EC1-9E40-2FCBDCE5D5B8",
        "short": "REST",
        "long": "Representational State Transfer",
        "user": {
            "id": "2D2D962C-728A-4381-BBDC-6838C634774E"
        }
    }
]</pre>
            </td>
        </tr>
    </tbody>
</table>

### Acronyms
<table>
    <thead>
        <tr>
            <th><br></th>
            <th>Status code & Message body<br></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td valign="top"><code><b>GET</b> /api/acronyms/</code></td>
            <td>
            <pre lang="json">
[
    {
        "id": "C238BBFF-8276-4EC1-9E40-2FCBDCE5D5B8",
        "short": "REST",
        "long": "Representational State Transfer",
        "user": {
            "id": "2D2D962C-728A-4381-BBDC-6838C634774E"
        }
    }
]</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>POST</b> /api/acronyms/</code></td>
            <td>
                <b>Request body:</b>
                <pre lang="json">
{
    "long": "Representational State Transfer",
    "short": "REST",
    "userID": "2D2D962C-728A-4381-BBDC-6838C634774E"
}</pre>
                <b>Response body:</b>
                <pre lang="json">
{
    "id": "C238BBFF-8276-4EC1-9E40-2FCBDCE5D5B8",
    "long": "Representational State Transfer",
    "short": "REST",
    "user": {
        "id": "2D2D962C-728A-4381-BBDC-6838C634774E"
    }
}</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>GET</b> /api/acronyms/:id</code></td>
            <td>
                <pre lang="json">
{
    "id": "C238BBFF-8276-4EC1-9E40-2FCBDCE5D5B8",
    "short": "REST",
    "long": "Representational State Transfer",
    "user": {
        "id": "2D2D962C-728A-4381-BBDC-6838C634774E"
    }
}</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>PUT</b> /api/acronyms/:id</code></td>
            <td>
                <b>Request body:</b>
                <pre lang="json">
{
    "long": "REPRESENTATIONAL STATE TRANSFER",
    "short": "REST",
    "userID": "2D2D962C-728A-4381-BBDC-6838C634774E"
}</pre>
                <b>Response body:</b>
                <pre lang="json">
{
    "id": "C238BBFF-8276-4EC1-9E40-2FCBDCE5D5B8",
    "long": "REPRESENTATIONAL STATE TRANSFER",
    "short": "REST",
    "user": {
        "id": "2D2D962C-728A-4381-BBDC-6838C634774E"
    }
}</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>DELETE</b> /api/acronyms/:id</code></td>
            <td>
                <code>204</code>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>GET</b> /api/acronyms/:id/user</code></td>
            <td>
                <pre lang="json">
{
    "id": "2D2D962C-728A-4381-BBDC-6838C634774E",
    "name": "Justin",
    "username": "hanjustin"
}</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>GET</b> /api/acronyms/:id/categories</code></td>
            <td>
                <pre lang="json">
[
    {
        "id": "012CDFD6-0EAA-484B-877A-8810CA8BB0A1",
        "name": "Programming"
    }
]</pre>
            </td>
        </tr>
        <tr>
            <td colspan="2"><code><b>POST</b> /api/acronyms/{:acronymID}/categories/{:categoryID}</code>
            <br>
                <code>201</code>
            </td>
        </tr>
        <tr>
            <td colspan="2">
              <code><b>DELETE</b> /api/acronyms/{:acronymID}/categories/{:categoryID}</code>
              <br>
              <code>204</code>
            </td>
        </tr>
    </tbody>
</table>



### Categories
<table>
    <thead>
        <tr>
            <th><br></th>
            <th>Status code & Message body<br></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td valign="top"><code><b>GET</b> /api/categories/</code></td>
            <td>
            <pre lang="json">
[
    {
        "id": "012CDFD6-0EAA-484B-877A-8810CA8BB0A1",
        "name": "Programming"
    }
]</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>POST</b> /api/categories/</code></td>
            <td>
                <b>Request body:</b>
                <pre lang="json">
{
    "name": "Programming"
}</pre>
                <b>Response body:</b>
                <pre lang="json">
{
    "id": "012CDFD6-0EAA-484B-877A-8810CA8BB0A1",
    "name": "Programming"
}</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>GET</b> /api/categories/:id</code></td>
            <td>
                <pre lang="json">
{
    "id": "012CDFD6-0EAA-484B-877A-8810CA8BB0A1",
    "name": "Programming"
}</pre>
            </td>
        </tr>
        <tr>
            <td valign="top"><code><b>GET</b> /api/categories/:id/acronyms</code></td>
            <td>
                <pre lang="json">
[
    {
        "id": "C238BBFF-8276-4EC1-9E40-2FCBDCE5D5B8",
        "short": "REST",
        "long": "Representational State Transfer",
        "user": {
            "id": "2D2D962C-728A-4381-BBDC-6838C634774E"
        }
    }
]</pre>
            </td>
        </tr>
    </tbody>
</table>
