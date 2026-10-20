# 🛒 ShopSphere - Advanced Java E-Commerce Platform

A complete enterprise Java e-commerce system built for the RTU Advanced Java course. It features a modern web store, desktop administration application, distributed RMI inventory service, and multi-threaded TCP network sockets.

---

## 📁 Project Structure

```
siddharth_java/
├── pom.xml                         # Root Maven POM (manages all modules)
├── database/
│   └── shopsphere.sql              # MySQL Database Schema & Seed Data
├── core-common/                    # Shared POJOs, JDBC DBConnection, and DAOs
├── web-app/                        # Jakarta EE 10 / Servlet 6.1 / JSP Web Application
├── swing-admin/                    # Java Swing Desktop Admin Application
├── rmi-service/                    # Java RMI Distributed Inventory Service
├── network-service/                # Java TCP Sockets & Object Serialization
├── PROJECT_REPORT.md               # 14-Section Capstone Project Report & Viva Q&A
└── Java_Advanced_ShopSphere_Project_Guide.docx  # Original Project Guide
```

---

## ⚡ Quick Start Guide (For Your Friend)

### 1. Prerequisites
Ensure you have the following installed on your machine:
* **Java JDK 17 or higher** (`java -version`)
* **Apache Maven 3.8+** (`mvn -version`)
* **MySQL 8.0+** running locally on port `3306`
* **Apache Tomcat 10 or 11** (Optional: only needed to host the WAR web store)

---

### 2. Database Setup (MySQL)
1. Start your local MySQL service.
2. Open terminal/command prompt and run:
   ```bash
   mysql -u root -p < database/shopsphere.sql
   ```
   *(If your MySQL root has no password, you can run: `mysql -u root < database/shopsphere.sql`)*

3. If your MySQL credentials are not `root` with no password, you can configure them in:
   `core-common/src/main/resources/db.properties`

---

### 3. Build the Whole Project
Run from the root directory:
```bash
mvn clean install
```
This compiles all modules and builds `web-app/target/web-app-1.0.0.war`.

---

### 4. Running the Modules

#### A. Web Customer Application (Tomcat)
1. Copy `web-app/target/web-app-1.0.0.war` into your Tomcat `webapps/` folder as `shopsphere.war`:
   ```bash
   cp web-app/target/web-app-1.0.0.war /path/to/tomcat/webapps/shopsphere.war
   ```
2. Start Tomcat (`bin/startup.sh` or `catalina run`).
3. Open browser: **[http://localhost:8080/shopsphere/](http://localhost:8080/shopsphere/)**
4. Academic Syllabus Demo Page: **[http://localhost:8080/shopsphere/syllabus-demo](http://localhost:8080/shopsphere/syllabus-demo)**

#### B. Java Swing Desktop Admin App
To launch the desktop administration window:
```bash
mvn exec:java -pl swing-admin -Dexec.mainClass="com.shopsphere.swing.SwingAdminApp"
```

#### C. Java RMI Distributed Inventory Service
1. Start the RMI Server (starts registry on port 1099):
   ```bash
   mvn exec:java -pl rmi-service -Dexec.mainClass="com.shopsphere.rmi.RmiInventoryServer"
   ```
2. In a second terminal, run the RMI test client:
   ```bash
   mvn exec:java -pl rmi-service -Dexec.mainClass="com.shopsphere.rmi.RmiInventoryClient"
   ```

#### D. TCP Sockets & Object Serialization Module
1. Start the Socket Server (listens on port 8888):
   ```bash
   mvn exec:java -pl network-service -Dexec.mainClass="com.shopsphere.network.InventorySocketServer"
   ```
2. In a second terminal, run the Socket Client:
   ```bash
   mvn exec:java -pl network-service -Dexec.mainClass="com.shopsphere.network.InventorySocketClient"
   ```

---

## 🔑 Default Login Credentials

| Role | Email | Password |
| :--- | :--- | :--- |
| **Customer** | `rahul@example.com` | `customer123` |
| **Administrator** | `admin@shopsphere.com` | `admin123` |

---

## 📖 Viva Preparation & Documentation
Refer to **`PROJECT_REPORT.md`** for:
* Full System Architecture & ER Diagrams
* 14-Section Capstone Report
* **Top 20 Viva Questions with Model Answers**
