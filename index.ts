import { serve } from "bun";

const PORT = Bun.env.PORT || 3000;

serve({
		port: PORT,
		routes: {
			'/': () => {
				return new Response("Hello, from Bun!");
			}
		}
	}
);