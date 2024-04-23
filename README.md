# Tencent Cloud Chat UIKit V2

Welcome to the Tencent Cloud Chat UIKit V2 repository which contains all the general and modular packages. You can use these packages to create engaging and feature-rich chat applications that cater to your business needs.

To start using these packages, you can clone or fork the repository and modify them as per your requirements. Each package comes with a detailed README file that provides information about its usage and features.

If you have any questions or need further information, please feel free to raise an issue or submit a pull request. We are here to help you in any way we can.

![uikit.png](https://comm.qq.com/im/static-files/uikit.jpg)

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

## Sample App

To make integration a breeze, we offer two sample apps complete with source code.

- **[Comprehensive Integration](https://github.com/TencentCloud/chat-demo-flutter/tree/v2)**: Includes a sample application that demonstrates most of the advanced features of the Tencent Cloud Chat UIKit V2.
- **[Simplified Integration](https://github.com/TencentCloud/chat-uikit-flutter/tree/v2/tencent_cloud_chat/example)**: Includes a basic sample application that showcases a simplified integration process for the Tencent Cloud Chat UIKit V2.
