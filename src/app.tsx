import { createCliRenderer } from "@opentui/core"
import { render } from "@opentui/solid"

const App = () => {
    return (
        <box width="100%" height="100%" backgroundColor="#14090A">
            <text>
                Please stand by while waiting for OPSEC to commence...
            </text>
            <video
                id="player"
                source="./fluffer.mp4"
                width={"100%"}
                height={"100%"}
                autoplay={true}
                loop={true}
                onError={console.log}
            />
        </box>
    )
}

Bun.spawn(["open", "https://soggy.cat"]);

const renderer = await createCliRenderer({ exitOnCtrlC: true })
await render(() => <App />, renderer)
