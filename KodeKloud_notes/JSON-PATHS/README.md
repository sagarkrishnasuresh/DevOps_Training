# JSON, YAML, and JSONPath – Complete Guide

## 1. What is JSON?

**JSON (JavaScript Object Notation)** is a lightweight, text-based data format used to represent structured data. It is widely used for transmitting data between servers and web applications.

### Key Features of JSON

* Human-readable and easy to understand.
* Based on key-value pairs.
* Language-independent but uses syntax similar to JavaScript objects.
* Commonly used for APIs and configuration files.

### Basic JSON Syntax

```json
{
  "name": "John Doe",
  "age": 30,
  "isEmployee": true,
  "skills": ["Java", "Python", "DevOps"],
  "address": {
    "city": "Bangalore",
    "zip": "560001"
  }
}
```

---

## 2. What is YAML?

**YAML (YAML Ain't Markup Language)** is a human-friendly data serialization language used for configuration files and data exchange between languages.

### Key Features of YAML

* Designed to be easily read and written by humans.
* Uses indentation for hierarchy (similar to Python).
* Widely used in **DevOps tools** (e.g., Kubernetes, Ansible, GitHub Actions).

### Basic YAML Syntax

```yaml
name: John Doe
age: 30
isEmployee: true
skills:
  - Java
  - Python
  - DevOps
address:
  city: Bangalore
  zip: 560001
```

---

## 3. Difference Between JSON and YAML

| Feature            | JSON                        | YAML                               |
| ------------------ | --------------------------- | ---------------------------------- |
| **File Extension** | `.json`                     | `.yaml` or `.yml`                  |
| **Readability**    | Machine-readable focus      | Human-readable focus               |
| **Syntax Style**   | Uses `{}`, `[]`, and quotes | Indentation-based, minimal symbols |
| **Data Types**     | Limited (string, number)    | Supports advanced (null, refs)     |
| **Comments**       | Not supported               | Supported using `#`                |
| **Use Cases**      | APIs, Web Data Exchange     | Configurations, DevOps tools       |

---

## 4. What is JSONPath?

**JSONPath** is a query language for extracting specific data from JSON documents, similar to how XPath works for XML.

### Basic JSONPath Syntax

* `$` – Root element
* `.` – Child operator
* `[]` – Array index or filter
* `*` – Wildcard (select all elements)
* `..` – Recursive descent
* `?()` – Filter expression

### Examples

Given the JSON:

```json
{
  "vehicles": [
    { "type": "car", "brand": "Tesla" },
    { "type": "bike", "brand": "Yamaha" },
    { "type": "car", "brand": "BMW" }
  ]
}
```

| JSONPath Query                        | Result                       |
| ------------------------------------- | ---------------------------- |
| `$.vehicles[*].type`                  | `["car", "bike", "car"]`     |
| `$.vehicles[0].brand`                 | `"Tesla"`                    |
| `$..brand`                            | `["Tesla", "Yamaha", "BMW"]` |
| `$.vehicles[?(@.type=="bike")].brand` | `["Yamaha"]`                 |

---

## 5. Practical JSONPath Command

If `q13.json` contains:

```json
[
  "car",
  "bus",
  "truck",
  "bike"
]
```

To extract "car" and "bike":

```bash
cat q13.json | jpath '$[0,3]'
```

Output:

```json
[
  "car",
  "bike"
]
```

---

## 6. Conclusion

* **JSON**: Best for APIs and machine-to-machine communication.
* **YAML**: Best for configuration and human-friendly editing.
* **JSONPath**: Powerful for querying and extracting data from JSON.

Both JSON and YAML are essential in modern development and DevOps workflows.
