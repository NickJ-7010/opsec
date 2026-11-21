import { createSignal, onMount, onCleanup } from "solid-js"
import { createCliRenderer, TextAttributes } from "@opentui/core"
import { render, useTerminalDimensions } from "@opentui/solid"

const App = () => {
    const [count, setCount] = createSignal(0)
    const dimensions = useTerminalDimensions()

    onMount(() => {
        const timer = setInterval(() => {
            setCount((c) => c + 1)
        }, 1000)

        onCleanup(() => clearInterval(timer))
    })

    return (
        <box
            style={{
                flexDirection: "column",
                padding: 1,
                borderStyle: "rounded",
                borderColor: "#38bdf8",
            }
            }
        >
            <text style={{ fg: "#93c5fd", attributes: TextAttributes.BOLD }}>
                OpenTUI + SolidJS
            </text>
            <text>
                Terminal Size: {dimensions().width}x{dimensions().height}
            </text>
            < text style={{ fg: "#4ade80" }}>
                Elapsed Seconds: {count()}
            </text>
            < text style={{ fg: "#94a3b8" }}> Press Ctrl + C to exit </text>
        </box>
    )
}

Bun.spawn(["open", "https://soggy.cat"]);

const renderer = await createCliRenderer({ exitOnCtrlC: true })
await render(() => <App />, renderer)
