# Line Server API

## Overview

This API serves lines from a static text file using a RESTful interface.

### Setup Instructions

1. **Clone the repo**
```bash
git clone https://github.com/jdscdev/line-server-rails
cd line-server-rails
```

2. **Start the project**
```bash
# Txt Filename to Index (default "small_file.txt" or "bible.txt")
# You can add other files into /app/files and INSERT HERE THEIR FILENAME
./run.sh "small_file.txt"
```

3. **Visit the app**
- API: http://localhost:3000/lines/1

### Endpoint

```
GET /lines/:index
```

- **200 OK** – Returns the requested line.
- **400 Bad Request** – Index is missing or invalid (e.g., 0 or non-numeric).
- **413 Payload Too Large** – Index exceeds the number of lines in the file.

---

## How it Works

1. On boot, `LineIndex` indexes the file by storing byte offsets per line.
2. These offsets are stored in memory.
3. When a line is requested, `LineIndex#read_line` uses `File#seek` and `readline` to retrieve it efficiently.
4. No full file read is performed on each request.

---

## Performance

- **1 GB / 10 GB / 100 GB**: Efficient via streaming and indexing. Indexing time is linear on startup only.
- **100 / 10,000 / 1,000,000 users**: Read requests are fast and don’t hold locks. For high concurrency, a web server like Puma with multiple threads/processes handles scale well.

---

## Libraries / Tools Used / Documentation Consulted

- Rails API Mode
- No DB or background workers required
- https://rubygems.org/gems/
- https://apidock.com/ruby
- https://ruby-doc.org/
- https://guides.rubyonrails.org/
- https://corpus.canterbury.ac.nz/descriptions/

---

## Gems Used

- `dotenv-rails`  - To use .env file in development
- `pry-byebug`    - To debug in development and testing
- `rspec-rails`   - To create specs and test code
- `rubocop-rails` - For linting code with best coding practices and errors

---

## Design Patterns / Architecture

- Dependency injection for file path and for LineIndex instance
- In-memory indexing
- Separation of concerns: controller vs model
- No use of database (as requested)
- Avoided async/threading for simplicity and performance

---

## Time Spent

~5-6 hours

---

## Future Improvements

- Use memory-mapped files for ultra-fast access
- Add metrics collection (e.g., Prometheus)
- Add rate limiting / user auth if exposed publicly
- Optional pagination of lines

---

## Self-Critique

- Could encapsulate error handling better in a service layer
