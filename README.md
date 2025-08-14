# Proof-of-Concept mirrord php-fpm

For ease of testing I've created a nix shell with all the dependencies preinstalled except docker. To use it just run `nix develop` or you can use automatic direnv activation by `direnv allow`.
Using nix is not necessary though, if you have the following tools preinstalled and available:

- PHP 8.4 (but any version could work)
- kind
- kubectl

If you'd like to use another type of kubernetes (local or remote) instead of kind, please make sure you update the [deploy.sh](./deploy.sh) script.

Spin up a default kind cluster:

```sh
./setup-cluster.sh
```

Deploy the application:

> This will build the [Dockerfile](./Dockerfile), push the image to the kind cluster, and deploy the app using [poc.yaml](./manifests/poc.yaml).

```sh
./deploy.sh
```

Test the application by opening a port to the nginx deployment:

```sh
kubectl port-forward deployments/nginx 8080:80
```

By browsing `http://localhost:8080/index.php` you should see the expected output :

```text
File /var/www/html/test.phpt69q7p0hleqs8jGjiKV created successfully 
File /var/www/html/test.php renamed successfully Hello, World!
```

By using mirrord capture the php-fpm traffic and send it to a local php-fpm process:

```sh
mirrord exec --config-file ./.mirrord/mirrord.json --target deployment/php-fpm php-fpm -- -y ./php-fpm.conf -F
```

Output after running mirrord:

```text
File /var/www/html/test.phpca772hb9tarv2wwailO created successfully
File /var/www/html/test.php failed to rename
Warning: include_once(/var/www/html/test.php): Failed to open stream: No such file or directory in /var/www/html/index.php on line 14

Warning: include_once(): Failed opening '/var/www/html/test.php' for inclusion (include_path='.:/nix/store/596kvq8a1zladwmyrwl357hm5639hzj1-php-8.4.11/lib/php') in /var/www/html/index.php on line 14
```

You can see that the `test.phpca772hb9tarv2wwailO` file is created in your local folder as expected, but the app failed to rename it to `test.php`.
