package com.example.yourapp;

import android.util.Log;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class Logging {
    public enum LogLevel {
        DEBUG(1), INFO(2), WARNING(3), ERROR(4);

        private final int level;

        LogLevel(int level) {
            this.level = level;
        }

        public int getLevel() {
            return level;
        }
    }

    private static LogLevel logLevel = LogLevel.DEBUG;
    private static File logFile;

    public static void setLogLevel(LogLevel level) {
        logLevel = level;
    }

    public static void setLogFile(File file) {
        logFile = file;
    }

    public static void log(String message, LogLevel level) {
        if (level.getLevel() >= logLevel.getLevel()) {
            String logMessage = "[" + level + "] " + message;
            Log.d("Logging", logMessage);
            if (logFile != null) {
                try (FileWriter writer = new FileWriter(logFile, true)) {
                    writer.write(logMessage + "\n");
                } catch (IOException e) {
                    Log.e("Logging", "Failed to write to log file", e);
                }
            }
        }
    }
}
