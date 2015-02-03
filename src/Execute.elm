module Execute where

{-| Execute scheduling and delivery of `Signal.Message` values. -}

import Native.Execute
import Signal (Signal, Message)

{-| Schedule the input `Message` values for delivery.

    The output signal has same event occurrences as the input signal,
    and there is no guarantee that effects of message delivery will
    be visible when the output `Signal ()` updates.

    Implementation uses `setTimeout(.., 0)`.
-}
schedule : Signal Message -> Signal ()
schedule = Native.Messages.schedule

{-| Schedule the input `Message` values for delivery and wait for
    completion of each delivery.

    Unlike `schedule`, the output `Signal` will refresh once _after_
    all effects of message delivery have propagated through the
    signal graph. There will be exactly one refresh of the output
    signal for each input `Message`, but the implementation uses
    `setTimeout(.., 0)` in JS so there aren't any guarantees about
    exact ordering, especially with regard to other events in the
    signal graph.
-}
complete : Signal Message -> Signal ()
complete = Native.Messages.complete
