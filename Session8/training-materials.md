# Session 8: Web Development with PowerShell and Pode

## 1. Web Development Basics

Before diving into web development with Pode, let's define some key terms:

### 1.1 What is an Endpoint?
An **endpoint** is a specific URL where an API receives requests. Example: `/api/urls`.

### 1.2 What is a Route?
A **route** maps HTTP methods (GET, POST, etc.) and URL paths to specific functions. In Pode, routes are defined using the `Add-PodeRoute` cmdlet.

### 1.3 HTTP Request and Response
- **Request**: The data a client sends to the server (e.g., asking for or sending data).
- **Response**: The server's answer, often with status codes (e.g., 200 OK).

### 1.4 Query String
Query strings are key-value pairs passed in the URL after `?`, e.g., `/search?query=example`.

---

## 2. Introduction to Pode

### 2.1 What is Pode?
Pode is a lightweight PowerShell framework that lets you create web applications and APIs. It supports features like routing, serving static files, and rendering dynamic views. We'll begin with simple routes and build our knowledge step-by-step.

### 2.2 Setting Up a Simple Pode Server
Here’s a basic setup that returns a simple JSON response:

```powershell
Start-PodeServer {
    Add-PodeEndpoint -Address * -Port 8080 -Protocol Http
    Add-PodeRoute -Method Get -Path "/hello" -ScriptBlock {
        Write-PodeJsonResponse -Value @{ message = "Hello World" }
    }
}
```

This will start a server on `http://localhost:8080/hello` that returns `{"message": "Hello World"}` in JSON format.

---

## 3. Understanding Pode Responses

### 3.1 JSON Response
Use `Write-PodeJsonResponse` to send a JSON response:

```powershell
Write-PodeJsonResponse -Value @{ Name = "John"; Department = "IT" }
```

### 3.2 Text Response
```powershell
Write-PodeTextResponse -Value "This is plain text"
```

### 3.3 File Download Response
To allow users to download a file:

```powershell
Set-PodeResponseAttachment -Path "~/Downloads/sample.pdf"
```

### 3.4 Redirect Response
Redirect users to another URL:

```powershell
Set-PodeResponseRedirect -Url "/new-location"
```

---

## 4. The `$WebEvent` Object

### 4.1 Overview
The `$WebEvent` object stores information about the current request (headers, body, query strings, etc.).

### 4.2 Key Attributes of `$WebEvent`

| Attribute            | Description                                        |
|----------------------|----------------------------------------------------|
| `$WebEvent.Path`      | The requested URL path (e.g., `/employees`)        |
| `$WebEvent.Data`      | Parsed body data (if JSON or form-data is sent)    |
| `$WebEvent.Query`     | Query string parameters (e.g., `?name=John`)       |
| `$WebEvent.Parameters` | URL route parameters (e.g., `/employees/:id`)     |

Example using URL parameters:

```powershell
Add-PodeRoute -Method Get -Path "/employees/:id/detail" -ScriptBlock {
    $id = $WebEvent.Parameters['id']
    Write-PodeJsonResponse -Value @{ employeeId = $id }
}
```

---

## 5. Project Folder Hierarchy in Pode

As we move toward building more complex apps, it's important to follow a standard project structure. Pode encourages a folder hierarchy for better organization.

### 5.1 Basic Project Structure

```
/MyPodeApp
    /Public            # For static assets like CSS and images
    /Views             # For HTML templates
    /Modules           # PowerShell modules used by the app
    server.ps1         # The main script to start the server
```

- **Public**: Stores static files (e.g., Bootstrap, images).
- **Views**: Stores dynamic HTML files rendered by Pode.

---

## 6. Views and Using Bootstrap

Pode supports views (HTML templates) for rendering dynamic content.

### 6.1 Rendering a Simple HTML Page
```powershell
Start-PodeServer {
    Add-PodeViewEngine -Extension ".html"
    Add-PodeRoute -Method Get -Path "/" -ScriptBlock {
        Write-PodeViewResponse -Path "index.html" -Data @{ Message = "Hello World" }
    }
}
```

### 6.2 Adding Bootstrap
To add Bootstrap to enhance the page's styling:

1. Download Bootstrap and place it in the `/Public` folder.
2. Modify the HTML page to use Bootstrap:

```html
<!DOCTYPE html>
<html>
<head>
    <link href="/static/bootstrap.min.css" rel="stylesheet">
    <title>Hello World</title>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Hello World</h5>
                <p>This is a Bootstrap styled card.</p>
            </div>
        </div>
    </div>
</body>
</html>
```

Update the server to serve static files:

```powershell
Start-PodeServer {
    Add-PodeStaticRoute -Path "/static" -Source "./Public"
    Add-PodeRoute -Method Get -Path "/" -ScriptBlock {
        Write-PodeViewResponse -Path "index.html"
    }
}
```

---

## 7. Logging in Pode

Pode makes logging easy. You can log to the terminal, a file, or both.

### 7.1 Enable Logging
```powershell
Start-PodeServer {
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging
    New-PodeLoggingMethod -File -Name Requests -MaxDays 14 | Enable-PodeRequestLogging
    New-PodeLoggingMethod -File -Name App -MaxSize 10MB | Enable-PodeErrorLogging -Levels Error, Informational, Warning
    Add-PodeRoute -Method Get -Path "/ping" -ScriptBlock {
        Write-PodeTextResponse -Value "pong"
    }
}
```

---

## 8. Working with Request Parameters

Pode allows you to handle different types of request parameters (query strings, body data, and URL parameters).

### 8.1 Query String Example
```powershell
Add-PodeRoute -Method Get -Path "/search" -ScriptBlock {
    $query = $WebEvent.Query["query"]
    Write-PodeTextResponse -Value "Searched for: $query"
}
```

### 8.2 Body Data Example
```powershell
Add-PodeRoute -Method Post -Path "/submit" -ScriptBlock {
    $data = $WebEvent.Data
    Write-PodeJsonResponse -Value $data
}
```

### 8.3 URL Parameter Example
```powershell
Add-PodeRoute -Method Get -Path "/user/:id" -ScriptBlock {
    $id = $WebEvent.Parameters['id']
    Write-PodeTextResponse -Value "User ID: $id"
}
```

### 8.4 Combined Example
```powershell
Add-PodeRoute -Method Post -Path "/user/:id" -ScriptBlock {
    $id = $WebEvent.Parameters['id']
    $queryParam = $WebEvent.Query["status"]
    $body = $WebEvent.Data
    Write-PodeJsonResponse -Value @{ ID = $id; Status = $queryParam; Data = $body }
}
```

---

## 9. Authentication in Pode

Pode supports integration with Active Directory for secure route handling.

### 9.1 Enabling Active Directory Authentication
```powershell
Start-PodeServer {
    Add-PodeAuthWindowsAD -Name "MyAD" -Groups @("Admins", "Users")
    # use like below for form authentication:
    # New-PodeAuthScheme -Form | Add-PodeAuthWindowsAd -Name 'Admins' -Groups 'Your AD Group Names' -FailureUrl '/login' -SuccessUrl '/' -FailureMessage 'Username or Password is incorrect.'
}
```

### 9.2 Securing Routes with Roles
```powershell
Add-PodeRoute -Method Get -Path "/secure" -Authentication MyAD -ScriptBlock {
    Write-PodeTextResponse -Value "Secure Data"
}
```

---

## 10. Building a URL Shortener Example

### 10.1 Project Setup
Let’s create a basic URL shortener using Pode. The project structure will be:

```
/MyUrlShortenerApp
    /Public
    /Views
    /Modules
    server.ps1
```

### 10.2 Creating Routes

1. **Shortening a URL (POST)**:
```powershell
Add-PodeRoute -Method Post -Path "/shorten" -ScriptBlock {
    $longUrl = $WebEvent.Data.Url
    $shortUrl = "http://localhost:8080/abc123"
    Write-PodeJsonResponse -Value @{ shortUrl = $shortUrl }
}
```

2. **Redirecting to the Original URL (GET)**:
```powershell
Add-PodeRoute -Method Get -Path "/:shortCode" -ScriptBlock {
    $shortCode = $WebEvent.Parameters['shortCode']
    # Lookup the long URL from a data source (e.g., a hashtable)
    $longUrl = "http://original-url.com"
    Set-PodeResponseRedirect -Url $longUrl
}
```

### 10.3 Adding Bootstrap to the UI
Use Bootstrap in your form for users to submit URLs.

---

## Conclusion

In this session, we covered:
- Basic web development concepts.
- How to create routes and handle different types of responses in Pode.
- Using request parameters, logging, and authentication.
- An end-to-end URL shortener project to demonstrate how these components work together.
