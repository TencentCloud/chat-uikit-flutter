# Tencent Cloud Chat UIKit

Welcome to the Tencent Cloud Chat UIKit repository! This repository hosts a collection of packages designed to provide a comprehensive suite of tools for building feature-rich and engaging chat applications. Our aim is to facilitate the development process and ensure a consistent user experience across both mobile and desktop environments.

## Repository Structure and Package Relationships

This repository adopts a monorepo structure, housing multiple packages under one roof. Each package focuses on a specific feature set, allowing you to pick and choose the components that best suit your application's needs.

The packages included in this repository are organized as follows:

- **Tencent Cloud Chat UI Component Library**: Base package for the following UIKit components
    - **tencent_cloud_chat**: This is the core package that provides basic chat functionalities.
        - **tencent_cloud_chat_intl**:  This package provides internationalization support for your chat applications.
        - **tencent_cloud_chat_common**: This package offers a set of versatile and reusable components to streamline development and ensure UI consistency.
        - **Modular UI Components (Import as needed)**:
            - **tencent_cloud_chat_conversation**: This package offers a conversation list that displays all participated conversations. 
            - **tencent_cloud_chat_message**: This package provides a comprehensive messaging experience for your chat applications.
            - **tencent_cloud_chat_contact**: This package is designed to provide a contact list for your chat applications.
            - **tencent_cloud_chat_user_profile**: This package enriches your chat applications with a detailed user profile page.
            - **tencent_cloud_chat_group_profile**: This package enriches your chat applications with a detailed group profile page.
            - **tencent_cloud_chat_search**: This package provides search functionality for your chat applications.
- **Supplementary Add-ons**:
    - **tencent_cloud_chat_push**: This package provides push notification support for your chat applications.
    - **tencent_cloud_chat_robot**: This package is designed to facilitate interactions with chat bots within your chat applications.
    - **tencent_cloud_chat_customer_service**: This package is designed to facilitate customer service interactions within your chat applications.

The architecture of our UIKit is shown below:

![](https://comm.qq.com/im/static-files/uikit_structure.png)

To use the new version of the UIKit, customers need to first import the `tencent_cloud_chat` package and then manually import the six modular UI component packages as needed.

By offering a modular and flexible structure, we enable developers to create customized chat applications that cater to their specific requirements, with the option to expand to web and desktop platforms or integrate supplementary add-ons for additional functionalities.

## Getting Started

To get started with using these packages, you can clone this repository and explore the individual packages. Each package includes its own README file with detailed information about its usage and features.

We hope this repository provides you with all the tools you need to create engaging and feature-rich chat applications. If you have any questions or need further information, feel free to raise an issue or submit a pull request.

## Sample App

For easy integration, we provides two sample app with source code.

- **[Comprehensive Integration](https://github.com/TencentCloud/chat-demo-flutter/tree/v2)**: This repo contains a comprehensive sample application showcasing most of the advantage usage of the Tencent Cloud Chat UIKit V2.
- **[Simplified Integration](https://github.com/TencentCloud/chat-uikit-flutter/tree/v2/tencent_cloud_chat/example)**: This repo contains a basic sample application showcasing a simplified integration process for Tencent Cloud Chat UIKit V2.
