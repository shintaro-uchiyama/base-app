import "../i18n"
import React, {Suspense} from "react";

export const decorators = [
    (Story) => (
        <Suspense fallback="Loading">
            <Story />
        </Suspense>
    ),
];