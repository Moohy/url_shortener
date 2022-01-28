[Home](../../README.md) / Repository Map

# Repository Map
```
├── build
├── cmd
│   └── url_shortener
│       ├── config
│       └── startup
├── internal
│   └── integration
│   └── service
└── pkg

```
- [build](../../build) \
Directory for all build related files, includes the likes of cloudbuild & dockerfiles.
- [cmd](../../cmd) \
Directory in which entry-point files are located for compilation targets/required at startup, such as the application config & cli or the initialisation of open cencus
- [docs](../../docs) \
Directory for storage of subjective READMEs. Main README markdown file is stored in the [root directory](../..)
- [internal](../../internal) \
Directory of Notification Centre-specific application code, not intended to be shared with others.
    - [service](../../internal/service) - gRPC api definition and related "commands" to orchestrate multiple integrations and return back to user.
- [pkg](../../pkg) \
Directory of common packages that aren't specific to the Notification Centre business logic, packages that could potentially be shared with others or extracted to a common library
- [vendor](../../vendor) \
Typical Golang project vendor folder - stores copies of project dependencies
