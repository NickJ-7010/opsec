import { createCliRenderer } from "@opentui/core"
import { render } from "@opentui/solid"

const App = () => {
    return (
        <text>
            Hello, Hacker! :3
        </text>
    )
}

// Bun.spawn(["open", "https://soggy.cat"]);

const renderer = await createCliRenderer({ exitOnCtrlC: true })
await render(() => <App />, renderer)
