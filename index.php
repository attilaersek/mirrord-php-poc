<?php

$file = dirname(__FILE__) . "/test.php";
$dir = dirname(__FILE__);
echo "Current directory: $dir\n";
echo "File to be created: $file\n";
$tmpFile = tempnam($dir, basename($file));
echo "Tempfile to be created: $tmpFile\n";
$content = "<?php\n echo 'Hello, World!';\n ?>";
$result = @file_put_contents($tmpFile, $content);
echo "File $tmpFile " . ($result ? "created successfully" : "failed to create") . "\n";
$result = @rename($tmpFile, $file);
echo "File $file " . ($result ? "renamed successfully" : "failed to rename") . "\n";

include_once $file;
