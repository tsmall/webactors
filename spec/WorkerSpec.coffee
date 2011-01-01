spawn_helper = (method, body) ->
  actor_id = WebActors[method]("spec/WorkerSpecStub.js")
  body_string = "(#{body})"
  WebActors.send actor_id, body_string
  actor_id

describe "WebActors.spawnWorker", ->
  it "should spawn a functioning actor", ->
    done = false

    WebActors.spawn ->
      worker_id = spawn_helper 'spawnWorker', ->
        WebActors.receive WebActors.$ARG, (reply_id) ->
          WebActors.send reply_id, "it works!"

      WebActors.send worker_id, WebActors.self()

      WebActors.receive WebActors.$ARG, (result) ->
        expect(result).toEqual("it works!")
        done = true

    waitsFor -> done

describe "Workers", ->
  it "should handle array messages", ->
    done = false

    WebActors.spawn ->
      worker_id = spawn_helper 'spawnWorker', ->
        WebActors.receive [WebActors.$ARG], (reply_id) ->
          WebActors.send reply_id, "it works!"

      WebActors.send worker_id, [WebActors.self()]

      WebActors.receive WebActors.$ARG, (result) ->
        expect(result).toEqual("it works!")
        done = true

    waitsFor -> done
