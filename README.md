# Passwordless Authentication with Flutter

## Requirements

- A [tru.ID Account](https://tru.id)
- A mobile phone with a SIM card and mobile data connection

## Getting Started

Clone the starter-files branch via:

```bash
git clone -b starter-files --single-branch https://github.com/tru-ID/passwordless-auth-flutter.git
```

If you're only interested in the finished code in main then run:

```bash
git clone -b main https://github.com/tru-ID/passwordless-auth-flutter.git
```

Create a [tru.ID Account](https://tru.id)

Install the tru.ID CLI via:

```bash
npm i -g @tru_id/cli

```

Input your **tru.ID** credentials which can be found within the tru.ID [console](https://developer.tru.id/console)

Install the **tru.ID** CLI [development server plugin](https://github.com/tru-ID/cli-plugin-dev-server)

Create a new **tru.ID** project within the root directory via:

```
tru projects:create passwordless-auth-flutter --project-dir .
```

Run the development server, pointing it to the directory containing the newly created project configuration. This will also open up a localtunnel to your development server making it publicly accessible to the Internet so that your mobile phone can access it when only connected to mobile data.

```
tru server -t
```

To start the project, ensure you have a physical device connected then run:

```bash
flutter run
```

> **Note** For a physical iOS device ensure you've [provisioned your project in XCode](https://flutter.dev/docs/get-started/install/macos#deploy-to-ios-devices)

## References

- [**tru.ID** docs](https://developer.tru.id/docs)

## Meta

Distributed under the MIT License. See [LICENSE](https://github.com/tru-ID/passwordless-auth-flutter/blob/main/LICENSE.md)

[**tru.ID**](https://tru.id)
