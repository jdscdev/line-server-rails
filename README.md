# Line Server API

## Overview

This API serves lines from a static text file using a RESTful interface.

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
2. These offsets are cached in memory using `Rails.cache`.
3. When a line is requested, `LineIndex#read_line` uses `File#seek` and `readline` to retrieve it efficiently.
4. No full file read is performed on each request.

---

## Performance

- **1 GB / 10 GB / 100 GB**: Efficient via streaming and indexing. Indexing time is linear on startup only.
- **100 / 10,000 / 1,000,000 users**: Read requests are fast and don’t hold locks. For high concurrency, a web server like Puma with multiple threads/processes handles scale well.

---

## Libraries / Tools Used

- Rails API Mode
- `Rails.cache` for memory-based instance storage
- No DB or background workers required

---

## Design Patterns / Architecture

- Dependency injection for file path
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
- Could make `LineIndex` injectable as a dependency, not just cached globally
