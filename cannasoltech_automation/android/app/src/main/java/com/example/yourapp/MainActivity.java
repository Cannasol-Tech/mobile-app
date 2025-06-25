package com.example.yourapp;

import android.os.Bundle;
import android.os.Environment;
import io.flutter.embedding.android.FlutterActivity;
import java.io.File;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // ...existing code...

        // Set up logging
        Logging.setLogLevel(Logging.LogLevel.DEBUG);
        File logFile = new File(getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS), "app.log");
        Logging.setLogFile(logFile);

        // Example log messages
        Logging.log("Application did finish launching", Logging.LogLevel.INFO);
        Logging.log("This is a debug message", Logging.LogLevel.DEBUG);
        Logging.log("This is a warning message", Logging.LogLevel.WARNING);
        Logging.log("This is an error message", Logging.LogLevel.ERROR);
    }
}
