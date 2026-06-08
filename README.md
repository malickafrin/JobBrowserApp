# Job Browser

## Setup Instructions

### Requirements

* Xcode 26+
* iOS 17.6+

### Running the App

1. Clone the repository.
2. Open `JobBrowser.xcodeproj` in Xcode.
3. Select an iOS Simulator or physical device.
4. Build and run (`⌘ + R`).

### Testing

Unit tests are provided for the ViewModel layer.

The ViewModel depends on the `JobService` protocol rather than a concrete implementation, allowing a mock service to be injected during testing. This enables deterministic testing of loading states, pagination, search behavior, empty results, and error scenarios without making network requests.

Run the `JobBrowserTests` target in Xcode to execute the unit tests.

### Test Coverage

Unit tests cover the core business logic of the application, including loading states, pagination, search behavior, empty states, error handling, and service interactions.

## Architecture

The application follows a lightweight MVVM architecture using SwiftUI, async/await and Combine.

### Layers

#### View

SwiftUI views are responsible only for rendering UI and forwarding user actions.

#### ViewModel

ViewModels manage screen state, coordinate data loading, pagination, search, and error handling. Views react to state changes via observable properties.

#### Service Layer

The service layer abstracts API access through protocols, enabling dependency injection and straightforward unit testing.

#### Networking Layer

A reusable networking client handles request creation, response validation, decoding, and retry behavior.

### Dependency Injection

Dependencies are injected into ViewModels through their initializers.

For example, JobListViewModel receives a JobService dependency via constructor injection rather than creating a concrete service internally.
The ViewModel depends on the JobService protocol, allowing different implementations to be supplied at runtime, such as a production service or a mock service used during testing.

This improves testability, enables easier mocking and stubbing and promotes better separation of concerns.

### Navigation

Navigation is implemented using `NavigationStack` and strongly typed route-based navigation rather than embedding navigation logic throughout views.

---

## Search Functionality

The assignment specifies that jobs should be searchable by job title and company name. However, the provided API exposes a single free-text search parameter and does not currently offer field-specific search capabilities.

Search requests are delegated to the backend using the available search parameter. This approach ensures that search operates across the complete dataset rather than only the jobs currently loaded through pagination.
A debounce mechanism is applied before triggering search requests to reduce unnecessary network calls while the user is typing.

Search state is reset when the query is cleared, restoring the default paginated job feed.

As field-specific filtering is not supported by the API, search results may include matches beyond job title and company name.

### Empty Search Results

During development, the API did not return an empty result set for search requests. Consequently, the "No Results Found" state could not be exercised using live API data.

The application still includes support for an empty search state, which was verified using mocked API responses during testing.

## Screenshots

### Job Listing

<img width="553" height="1054" alt="image" src="https://github.com/user-attachments/assets/47b8884c-4c0f-4772-ad0c-85cce0c13811" />

### Search Results

<img width="553" height="1054" alt="image" src="https://github.com/user-attachments/assets/e6f22bbb-d179-4730-93be-64cf4af77f39" />

<img width="553" height="1054" alt="image" src="https://github.com/user-attachments/assets/7d1c3924-e301-415a-ba61-cf2b170aee7f" />

### Job Details

<img width="553" height="1054" alt="image" src="https://github.com/user-attachments/assets/48418f1f-183c-4030-bd86-82bc5a12b630" />

### Mocked Empty Search State

<img width="553" height="1054" alt="image" src="https://github.com/user-attachments/assets/3da86a77-c668-48cf-ba57-93156485ce8b" />

### Network unavailable

<img width="553" height="1054" alt="image" src="https://github.com/user-attachments/assets/ba8e8f3d-5522-45db-be15-1590b218cd3e" />

---

## HTML Rendering

Job descriptions returned by the API are provided as HTML strings rather than plain text.

To preserve formatting and improve readability, job descriptions are rendered using HTML-to-attributed-text conversion instead of displaying raw HTML markup.

---

## Image Loading

Company logos are loaded using SwiftUI's built-in `AsyncImage`.

For simplicity, no custom image caching layer was implemented in this demo application.

In a production application, a dedicated image caching solution would likely be introduced to:

* Reduce network usage
* Improve scrolling performance
* Improve offline behavior

---

## Salary Formatting

Salary formatting is implemented as a presentation concern rather than business logic.

Formatting is intentionally kept outside the ViewModel to:

* Keep ViewModels focused on state management
* Improve testability
* Avoid coupling business state to display formatting rules

---

## Assumptions Made

## API

This application uses the Himalayas Jobs API.

The API provides:

- Paginated job listings
- Company information and logo URLs
- Job descriptions as HTML content
- Salary and location information
- Free-text search functionality

The API response contains all information required to render both the job listing and job details screens, eliminating the need for an additional job details request.

No authentication is required for accessing the API.

### Job Identification

The API does not provide a dedicated identifier for each job.

The `guid` field returned by the API is therefore used as the application's identifier. The value is a unique job URL and is assumed to uniquely identify a job posting within the dataset.

### No Job Details Endpoint

The API response already contains all information required by the Job Details screen, including description, company information, salary information, and application URL.

Therefore, no additional job details API call is performed when navigating to the details screen.

### Duplicate Jobs

The API may return duplicate job postings across pages.

To avoid displaying duplicates, newly loaded jobs are filtered against existing jobs using their identifier before being appended to the list.

### Pagination

The Himalayas Jobs API supports pagination through `offset` and `limit` query parameters.

The API restricts the maximum page size to 20 jobs per request. Therefore, the application requests jobs in batches of 20 and loads additional pages as the user approaches the end of the currently displayed results.

This approach reduces initial load time, limits network usage, and avoids downloading the entire dataset upfront.

To prevent duplicate entries from appearing in the UI, newly fetched jobs are filtered against existing jobs using their identifier before being appended to the list.


---

## Future Improvements

* Dedicated image caching using a library such as Nuke or Kingfisher
* Pull-to-refresh support
* Offline caching
* Analytics and monitoring
* Field-specific search support if exposed by the backend API
* Enhanced accessibility testing
* Additional UI and integration tests
