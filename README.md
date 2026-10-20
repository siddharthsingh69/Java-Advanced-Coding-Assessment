# Advanced Java Programming Laboratory & Enterprise Capstone

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-11-yellow.svg)](https://tomcat.apache.org/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-blue.svg)](https://jakarta.ee/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue.svg)](https://www.mysql.com/)
[![Build](https://img.shields.io/badge/Build-Maven-red.svg)](https://maven.apache.org/)
[![Curriculum](https://img.shields.io/badge/University-RTU%20Syllabus-green.svg)](#)

A comprehensive, industry-aligned repository covering the entire **Advanced Java Laboratory Curriculum** (Experiments 1 through 7) alongside **ShopSphere**, a complete N-Tier enterprise e-commerce capstone application.

**Student:** Siddharth Singh &nbsp;|&nbsp; **Roll No:** 24egjad049 &nbsp;|&nbsp; **Section:** E

---

## Table of Contents

- [Repository Overview](#repository-overview)
- [Directory Structure](#directory-structure)
- [Lab Experiments (1 to 7)](#lab-experiments-1-to-7)
  - [Exp 1: Student Registration GUI (Java Swing)](#exp-1-student-registration-gui-java-swing)
  - [Exp 2: Student Application following MVC Architecture](#exp-2-student-application-following-mvc-architecture)
  - [Exp 3: Java Database Connectivity (JDBC)](#exp-3-java-database-connectivity-jdbc)
  - [Exp 4: TCP Socket Client-Server Network Programming](#exp-4-tcp-socket-client-server-network-programming)
  - [Exp 5: Remote Method Invocation (Java RMI)](#exp-5-remote-method-invocation-java-rmi)
  - [Exp 6: Jakarta Servlet, Filters, Sessions & Listeners](#exp-6-jakarta-servlet-filters-sessions--listeners)
  - [Exp 7: HTML to Dynamic JSP Conversion & Expression Language](#exp-7-html-to-dynamic-jsp-conversion--expression-language)
- [Capstone Project: ShopSphere Enterprise Suite](#capstone-project-shopsphere-enterprise-suite)
- [Software Prerequisites & Environment](#software-prerequisites--environment)
- [Execution & Verification Guide](#execution--verification-guide)
- [Common Troubleshooting](#common-troubleshooting)

---

## Repository Overview

| Experiment / Module | Topic / Focus | Key Technologies | Location |
| :--- | :--- | :--- | :--- |
| **Exp 1** | GUI Design & Event Handling | Java Swing, `JFrame`, `ActionListener` | `Exp - 1 - Swing - Student Registration Form/` |
| **Exp 2** | Model-View-Controller (MVC) Pattern | Swing console MVC, decoupled architecture | `Exp - 2 - MVC - Student Application/` |
| **Exp 3** | Database CRUD Operations | JDBC, `PreparedStatement`, MySQL 8 | `Exp - 3 - JDBC - Insert and Display/` |
| **Exp 4** | Network Stream Programming | `java.net.Socket`, `ServerSocket`, TCP | `Exp - 4 - Client Server - Message Communication/` |
| **Exp 5** | Distributed Systems & Remoting | Java RMI, Remote Interface, Registry | `Exp - 5 - RMI - Calculator/` |
| **Exp 6** | Server-Side Web Programming | Jakarta Servlets, `HttpSession`, Filters | `Exp - 6 - servlet - 01/` |
| **Exp 7** | Dynamic Presentation & MVC View | JSP, Expression Language (EL) | `Exp - 7 - servlet - 02 HTML to JSP/` |
| **Capstone** | Full E-Commerce Platform | Servlets + JSP + Swing Admin + JDBC + RMI + Sockets | `ShopSphere/` |

---

## Directory Structure

```text
Java Advanced Coding Assessment/
│
├── Exp - 1 - Swing - Student Registration Form/
│   └── StudentRegistration.java
│
├── Exp - 2 - MVC - Student Application/
│   ├── StudentModel.java
│   ├── StudentView.java
│   ├── StudentController.java
│   └── Main.java
│
├── Exp - 3 - JDBC - Insert and Display/
│   ├── lib/mysql-connector-j-26.7.0.jar
│   ├── src/JdbcDemo.java
│   ├── setup.sql
│   └── bin/
│
├── Exp - 4 - Client Server - Message Communication/
│   ├── Server.java
│   └── Client.java
│
├── Exp - 5 - RMI - Calculator/
│   ├── Calculator.java
│   ├── CalculatorImpl.java
│   ├── Server.java
│   └── Client.java
│
├── Exp - 6 - servlet - 01/
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/servlet/
│       │   ├── LoginServlet.java
│       │   ├── HomeServlet.java
│       │   ├── AuthFilter.java
│       │   └── AppListener.java
│       └── webapp/index.html
│
├── Exp - 7 - servlet - 02 HTML to JSP/
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/servlet/HelloServlet.java
│       └── webapp/
│           ├── student.jsp
│           └── result.jsp
│
└── ShopSphere/                         # Capstone: ShopSphere E-Commerce System
    ├── pom.xml                         # Parent Maven POM (all modules)
    ├── database/shopsphere.sql
    ├── core-common/                    # Models, DAOs, DBConnection
    ├── web-app/                        # Jakarta Servlets, JSP storefront & admin
    ├── swing-admin/                    # Swing desktop administration suite
    ├── rmi-service/                    # Distributed RMI inventory service
    ├── network-service/                # Multi-threaded TCP inventory sockets
    └── PROJECT_REPORT.md
```

---

## Lab Experiments (1 to 7)

### Exp 1: Student Registration GUI (Java Swing)

* **Objective**: Design a graphical user interface for a student registration form using Java Swing components and event listeners.
* **Key Components**: `JFrame`, `JLabel`, `JTextField`, `JTextArea`, `JRadioButton` with `ButtonGroup`, `JComboBox`, `JCheckBox`, `JButton`, and `JOptionPane`.
* **Validation Features**: Restricts name to letters/spaces, age to 2-digit numbers, and requires terms agreement before submit; reset clears the form.
* **Execution**:

```bash
cd "Exp - 1 - Swing - Student Registration Form"
javac StudentRegistration.java
java StudentRegistration
```

---

### Exp 2: Student Application following MVC Architecture

* **Objective**: Build a student record application with strict separation of concerns using the Model-View-Controller design pattern.
* **Architecture**:
  * **Model (`StudentModel.java`)**: Holds student id, name, and course.
  * **View (`StudentView.java`)**: Collects input and displays student details.
  * **Controller (`StudentController.java`)**: Transfers data between View and Model.
  * **Entry Point (`Main.java`)**: Bootstraps and binds the MVC triad.
* **Execution**:

```bash
cd "Exp - 2 - MVC - Student Application"
javac *.java
java Main
```

---

### Exp 3: Java Database Connectivity (JDBC)

* **Objective**: Connect Java applications to relational database management systems using JDBC, execute parameterized queries, and read result sets.
* **Database Setup**:

```sql
CREATE DATABASE college;
USE college;
CREATE TABLE student (
    id INT PRIMARY KEY,
    name VARCHAR(30),
    branch VARCHAR(20)
);
```

Or run `setup.sql` from `Exp - 3 - JDBC - Insert and Display/`.

* **Key Components**:
  * `Class.forName("com.mysql.cj.jdbc.Driver")`: Dynamic driver loading into JVM memory.
  * `DriverManager.getConnection(...)`: Connects to `jdbc:mysql://localhost:3306/college`.
  * `PreparedStatement`: Parameterized insert (`insert into student values(?,?,?)`) preventing SQL injection.
  * `Statement` & `ResultSet`: Executes query and navigates cursor rows.
* **Execution**:

```bash
cd "Exp - 3 - JDBC - Insert and Display"
javac -cp "lib/*" -d bin src/*.java
java -cp "bin;lib/*" JdbcDemo
```

Update the MySQL username/password in `src/JdbcDemo.java` to match your local server.

---

### Exp 4: TCP Socket Client-Server Network Programming

* **Objective**: Implement connection-oriented network communication using stream sockets in the `java.net` package.
* **Key Components**:
  * **Server (`Server.java`)**: Listens on port `5000` via `ServerSocket`, accepts a client, reads a message via `BufferedReader`, and replies via auto-flushing `PrintWriter`.
  * **Client (`Client.java`)**: Connects to `localhost:5000`, sends a message, reads the server response, and closes the socket.
* **Execution**:
  * *Terminal 1 (Server)*:

    ```bash
    cd "Exp - 4 - Client Server - Message Communication"
    javac *.java
    java Server
    ```

  * *Terminal 2 (Client)*:

    ```bash
    cd "Exp - 4 - Client Server - Message Communication"
    java Client
    ```

---

### Exp 5: Remote Method Invocation (Java RMI)

* **Objective**: Develop a distributed Java application where a client calls methods of an object residing in a different JVM over the network.
* **Architecture**:
  * **Remote Interface (`Calculator.java`)**: Extends `java.rmi.Remote` and declares `add` / `subtract`.
  * **Remote Object (`CalculatorImpl.java`)**: Implements the calculator business logic.
  * **Server (`Server.java`)**: Creates the remote object and binds it as `rmi://localhost/CalculatorService`.
  * **Client (`Client.java`)**: Looks up the remote reference and invokes remote methods.
* **Execution**:
  * *Terminal 1 (Server)*:

    ```bash
    cd "Exp - 5 - RMI - Calculator"
    javac *.java
    java Server
    ```

  * *Terminal 2 (Client)*:

    ```bash
    cd "Exp - 5 - RMI - Calculator"
    java Client
    ```

---

### Exp 6: Jakarta Servlet, Filters, Sessions & Listeners

* **Objective**: Study server-side Java programming with Jakarta Servlets on Apache Tomcat.
* **Key Components**:
  * **`LoginServlet.java`**: Authenticates credentials, creates a server-side `HttpSession`, and stores session attributes.
  * **`AuthFilter.java`**: `@WebFilter("/home")` intercepts incoming requests to protect resources from unauthenticated access.
  * **`HomeServlet.java`**: Protected servlet rendering user state from the session.
  * **`AppListener.java`**: `@WebListener` tracking application startup and shutdown events.
* **Build & Deployment**:

```bash
cd "Exp - 6 - servlet - 01"
mvn clean package
# Output: target/servlet.war -> Deploy to Tomcat webapps/
```

---

### Exp 7: HTML to Dynamic JSP Conversion & Expression Language

* **Objective**: Convert static HTML forms into dynamic JavaServer Pages (**JSP**), separating presentation from controller logic using Expression Language (**EL**).
* **Key Components**:
  * **`student.jsp`**: User input view with page directives and a registration form.
  * **`HelloServlet.java`**: Controller reading parameters, attaching data to request scope via `request.setAttribute()`, and forwarding via `RequestDispatcher`.
  * **`result.jsp`**: Dynamic view rendering `${name}`, `${email}`, `${course}`, `${age}` without scriptlets.
* **Build & Deployment**:

```bash
cd "Exp - 7 - servlet - 02 HTML to JSP"
mvn clean package
# Output: target/servlet.war -> Deploy to Tomcat webapps/
```

---

## Capstone Project: ShopSphere Enterprise Suite

**ShopSphere** is a complete, production-grade e-commerce application engineered for the RTU Advanced Java Capstone requirement.

```
+-------------------------------------------------------------------------+
|                         ShopSphere Enterprise Suite                     |
+------------------------------------+------------------------------------+
|         Web Client Portal          |      Desktop Admin Suite (Swing)   |
|     (Jakarta Servlets, JSP, EL)    |    (JTable, KPI Dashboard, MVC)    |
+------------------------------------+------------------------------------+
|                           Service Layer                                 |
|     (AuthService, CartService, OrderService, ProductService)            |
+-------------------------------------------------------------------------+
|                             DAO Layer                                   |
|        (UserDAO, ProductDAO, CategoryDAO, OrderDAO, CartDAO)            |
+-------------------------------------------------------------------------+
|                 JDBC + Distributed Inventory Services                   |
|              (DBConnection, RMI Inventory, TCP Sockets)                 |
+-------------------------------------------------------------------------+
|                           MySQL 8.0 Database                            |
|             (ACID Transactions, InnoDB Engine, Schema Seed)             |
+-------------------------------------------------------------------------+
```

### Core Architecture Highlights

1. **Dual Access Modalities**:
   * **Web Storefront**: Customer portal for catalog browsing, search, cart, checkout, and order history.
   * **Desktop Administration Suite (`SwingAdminApp.java`)**: Standalone Swing GUI for catalog, orders, and user administration.
2. **Distributed Services**:
   * **RMI Inventory Service** on port `1099` (`InventoryService`).
   * **TCP Socket Inventory Server** on port `8888` with object serialization.
3. **Web Stack**: Jakarta Servlet 6.1, JSP, JSTL, session filters (`AuthenticationFilter`, `AdminFilter`), and application/session listeners.
4. **Pre-Configured Evaluation Accounts**:

| Role | Email | Password |
| :--- | :--- | :--- |
| **Administrator** | `admin@shopsphere.com` | `admin123` |
| **Customer** | `siddharth@example.com` | `customer123` |

---

## Software Prerequisites & Environment

* **Java Development Kit (JDK)**: Version 17 or 21 (`java -version`, `javac -version`).
* **Web Server**: Apache Tomcat 10 or 11.
* **Database**: MySQL Server 8.0 listening on port `3306`.
* **Build System**: Apache Maven 3.8+.
* **Operating System**: Microsoft Windows 10 / 11.

---

## Execution & Verification Guide

### 1. Starting the MySQL Service

Ensure the `MySQL80` service is running in Windows:

* Press `Win + R`, type `services.msc`, locate `MySQL80`, and click **Start**.
* Or run in an Administrator command prompt: `net start MySQL80`.

### 2. Setting Up the ShopSphere Database

```bash
cd ShopSphere
mysql -u root -p < database/shopsphere.sql
```

Copy `core-common/src/main/resources/db.properties.example` to `db.properties` and set your local MySQL password.

### 3. Build All ShopSphere Modules

```bash
cd ShopSphere
mvn clean install
```

This produces `web-app/target/shopsphere.war`.

### 4. Deploying and Running the Web Store

1. Copy `ShopSphere/web-app/target/shopsphere.war` into Tomcat `webapps/`.
2. Start Tomcat.
3. Open [http://localhost:8080/shopsphere/](http://localhost:8080/shopsphere/)
4. Syllabus demo page: [http://localhost:8080/shopsphere/syllabus-demo](http://localhost:8080/shopsphere/syllabus-demo)

### 5. Running the Desktop Swing Admin Suite

```bash
cd ShopSphere
mvn exec:java -pl swing-admin -Dexec.mainClass="com.shopsphere.swing.SwingAdminApp"
```

### 6. Running RMI Inventory Service

*Terminal 1 (Server)*:

```bash
cd ShopSphere
mvn exec:java -pl rmi-service -Dexec.mainClass="com.shopsphere.rmi.RmiInventoryServer"
```

*Terminal 2 (Client)*:

```bash
cd ShopSphere
mvn exec:java -pl rmi-service -Dexec.mainClass="com.shopsphere.rmi.RmiInventoryClient"
```

### 7. Running TCP Socket Inventory Service

*Terminal 1 (Server)*:

```bash
cd ShopSphere
mvn exec:java -pl network-service -Dexec.mainClass="com.shopsphere.network.InventorySocketServer"
```

*Terminal 2 (Client)*:

```bash
cd ShopSphere
mvn exec:java -pl network-service -Dexec.mainClass="com.shopsphere.network.InventorySocketClient"
```

---

## Common Troubleshooting

| Issue / Error | Root Cause | Solution |
| :--- | :--- | :--- |
| `CommunicationsException: Communications link failure` | MySQL service is stopped. | Start `MySQL80` via `services.msc` or `net start MySQL80`. |
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | JDBC driver JAR is missing from classpath. | Ensure `-cp "lib/*"` or the Maven MySQL dependency is included. |
| Access denied for MySQL user | Local password does not match config. | Update `JdbcDemo.java` or `ShopSphere/.../db.properties`. |
| `Address already in use: bind (Port 8080)` | Another process is holding Tomcat port. | Stop the existing Tomcat instance or kill the conflicting process. |
| `Connection refused: localhost:5000 / 1099 / 8888` | Server not started before client. | Start the matching Server process first, then the Client. |
| `HTTP 404 Not Found` | Context path mismatch or WAR not deployed. | Deploy `shopsphere.war` / `servlet.war` into Tomcat `webapps/`. |

---

### Author & Academic Credits

* **Student**: Siddharth Singh
* **Roll No.**: 24egjad049
* **Section**: E
* **Project**: RTU Advanced Java / Java Enterprise Laboratory Suite
* **Technologies**: Java SE, Java Swing, JDBC, Java Sockets, Java RMI, Jakarta Servlets, JSP, JSTL, Apache Tomcat, MySQL
* **Year**: 2026
