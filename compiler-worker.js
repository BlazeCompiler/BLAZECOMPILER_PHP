const { parentPort, workerData } = require("worker_threads");
const { spawnSync } = require("child_process");

try {
    const { code, input } = workerData;

    // Write the code to a temporary file
    const fs = require("fs");
    const sourceFile = "/tmp/temp.php";
    fs.writeFileSync(sourceFile, code);


    // Execute the PHP code
    const runProcess = spawnSync("php", [sourceFile], {
        input,
        encoding: "utf-8",
        timeout: 5000, // Timeout after 5 seconds
    });

    // Check for execution errors
    if (runProcess.error) {
        console.error("Error executing PHP:", runProcess.error.message);
        return parentPort.postMessage({
            error: { fullError: `Runtime Error: ${runProcess.error.message}` },
        });
    }

    if (runProcess.stderr) {
        console.error("PHP stderr:", runProcess.stderr);
        return parentPort.postMessage({
            error: { fullError: `Runtime Error: ${runProcess.stderr}` },
        });
    }

    parentPort.postMessage({
        output: runProcess.stdout || "No output received!",
    });
} catch (err) {
    console.error("Worker thread error:", err.message);
    parentPort.postMessage({
        error: { fullError: `Internal Worker Error: ${err.message}` },
    });
}
