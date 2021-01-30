import React, { ComponentProps } from "react";
import { Story } from "@storybook/react/types-6-0";

import GoogleSignInButton from "./GoogleSignInButton";

export default {
  title: "atoms/GoogleSignIn",
  component: GoogleSignInButton,
};

const Template: Story<ComponentProps<typeof GoogleSignInButton>> = (args) => (
  <GoogleSignInButton {...args} />
);

export const GoogleSignInStory = Template.bind({});
GoogleSignInStory.args = {};
