# Tracer Bullet Protocol (Pragmatic Programmer Doctrine)

A tracer bullet is a complete, ultra-thin vertical slice through all architectural layers of the application. It is real code that stays in the codebase.

## Phase Timeline (Hour 0 - Hour 2)
1. **Hour 0:00 - 0:15: Define the Slice**
   - Pick the single end-to-end happy path flow.
   - Example: User types text -> API route receives -> Controller validates -> DB records -> UI updates live.
2. **Hour 0:15 - 0:35: The Skeleton**
   - Create the minimal files for all layers simultaneously.
   - Stub the interface types and endpoint signatures.
3. **Hour 0:35 - 1:20: Wire the Path**
   - Connect the real database connection and HTTP route.
   - Send mock data through real network pipes.
4. **Hour 1:20 - 1:40: Exercise Reality**
   - Run the application. Click the button or execute curl.
   - Verify that data lands in the database and echoes back to the UI.
5. **Hour 1:40 - 2:00: Lock Foundation**
   - Commit the working tracer bullet.
   - Now, and only now, begin fleshing out secondary logic.

## Failure Conditions
- DO NOT build the full database schema before connecting the frontend.
- DO NOT build full frontend state management before hitting a live endpoint.
