// GoogleSignIn.stories.tsx

import React, { ComponentProps } from "react";
import { Story } from "@storybook/react/types-6-0";

import GoogleSignIn from "./GoogleSignIn";

// This default export determines where your story goes in the story list
export default {
  title: "GoogleSignIn",
  component: GoogleSignIn,
};

const Template: Story<ComponentProps<typeof GoogleSignIn>> = (args) => (
  <GoogleSignIn {...args} />
);

export const GoogleSignInStory = Template.bind({});
GoogleSignInStory.args = {
  /* the args you need here will depend on your component */
};
