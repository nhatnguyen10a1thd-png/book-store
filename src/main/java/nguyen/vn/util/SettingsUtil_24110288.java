package nguyen.vn.util;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public final class SettingsUtil_24110288 {
    private static final Map<String, String> LOCAL_ENV = loadLocalEnv();

    private SettingsUtil_24110288() {
    }

    public static String get(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            value = System.getProperty(name);
        }
        if (value == null || value.isBlank()) {
            value = LOCAL_ENV.get(name);
        }
        return value == null || value.isBlank() ? null : value;
    }

    public static String get(String name, String defaultValue) {
        String value = get(name);
        return value == null ? defaultValue : value;
    }

    private static Map<String, String> loadLocalEnv() {
        Map<String, String> values = new ConcurrentHashMap<>();
        for (Path candidate : envCandidates()) {
            if (!Files.isRegularFile(candidate)) {
                continue;
            }
            try {
                for (String line : Files.readAllLines(candidate, StandardCharsets.UTF_8)) {
                    parseLine(line, values);
                }
                break;
            } catch (IOException ignored) {
            }
        }
        return values;
    }

    private static Set<Path> envCandidates() {
        Set<Path> candidates = new LinkedHashSet<>();
        String explicitPath = System.getenv("BOOKSTORE_ENV_FILE");
        if (explicitPath == null || explicitPath.isBlank()) {
            explicitPath = System.getProperty("BOOKSTORE_ENV_FILE");
        }
        if (explicitPath != null && !explicitPath.isBlank()) {
            candidates.add(Path.of(explicitPath).toAbsolutePath().normalize());
        }

        addParents(candidates, Path.of(System.getProperty("user.dir", ".")));
        try {
            Path codeLocation = Path.of(SettingsUtil_24110288.class.getProtectionDomain()
                    .getCodeSource().getLocation().toURI());
            addParents(candidates, codeLocation);
        } catch (URISyntaxException | NullPointerException ignored) {
        }
        return candidates;
    }

    private static void addParents(Set<Path> candidates, Path start) {
        Path current = start.toAbsolutePath().normalize();
        if (Files.isRegularFile(current)) {
            current = current.getParent();
        }
        for (int depth = 0; current != null && depth < 8; depth++) {
            candidates.add(current.resolve(".env"));
            current = current.getParent();
        }
    }

    private static void parseLine(String line, Map<String, String> values) {
        String trimmed = line.trim();
        if (trimmed.isEmpty() || trimmed.startsWith("#")) {
            return;
        }
        int separator = trimmed.indexOf('=');
        if (separator <= 0) {
            return;
        }
        String key = trimmed.substring(0, separator).trim();
        String value = trimmed.substring(separator + 1).trim();
        if (value.length() >= 2 && ((value.startsWith("\"") && value.endsWith("\""))
                || (value.startsWith("'") && value.endsWith("'")))) {
            value = value.substring(1, value.length() - 1);
        }
        values.put(key, value);
    }
}
