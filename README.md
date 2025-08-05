# ContentSwitcherPlayground

This projects shows a way to use a custom container view controller to in-place switch view controllers.

```mermaid
flowchart TD
        A(["root"])
        A -- taps --> B["color"]
        A -- opens --> C["menu"]
        C -- selects --> B["color"]
        B -- pushes --> D["detail"]
        D -- opens --> E["menu"]
        E -- selects --> F["color"]
        F -- replaces --> D["detail"]
```
