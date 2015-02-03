This library provides two new primitive functions for executing delivery of `Signal.Message` values:

```Elm
-- Output refreshes when messages are scheduled for delivery
schedule : Signal Message -> Signal ()

-- Output refreshes after each message is delivered
complete : Signal Message -> Signal ()
```

In conjunction with `Signal.channel`, it can be used to create cyles in Elm's signal graph. For example:

```Elm
loop : (Signal a -> Signal s -> Signal (b,s)) -> s -> Signal a -> Signal b
loop f s a =
  let chan = channel s
      bs = f a (sampleOn a (subscribe chan)) -- Signal (b,s)
  in map2 always (map fst bs)
                 (Execute.complete (map (\(_,s) -> send chan s) bs))

-- NB: Just for illustration purposes!
-- `foldp (+) 0` is a much more sane implementation of this function
runningSum : Signal Int -> Signal Int
runningSum a =
  loop (\a acc -> map2 (+) a acc |> map (\a -> (a,a))) 0 a
```

Neither this library nor Elm will prevent you from writing unguarded positive feedback loops in which an input refresh triggers an infinite number of updates due to outputs being looped back. For example, the following implementation of `loop` has an unguarded feedback loop:

```Elm
loop' : (Signal a -> Signal s -> Signal (b,s)) -> s -> Signal a -> Signal b
loop' f s a =
  let chan = channel s
      bs = f a (subscribe chan) -- uh oh! our loopback triggers another update
  in map2 always (map fst bs)
                 (Execute.complete (map (\(_,s) -> send chan s) bs))

runningSum : Signal Int -> Signal Int
runningSum a =
  loop' (\a acc -> map2 (+) a acc |> map (\a -> (a,a))) 0 a
```

Exercise caution in using this library. Recommended usage is to implement safer functions in terms of these primitives.
