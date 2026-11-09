# ここで宣言しない ~/.claude/skills 配下のエントリには触らない。各ツールが自分で管理するものがある:
# - synced/: Claude Code が同期する
# - rex/: `rex skill setup` が置く
{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  github = inputs.agents-nix.agent-skills.${pkgs.stdenv.hostPlatform.system}.github;

  fromRepo = src: names: lib.genAttrs names (name: "${src}/skills/${name}");

  skills =
    {
      inherit (github.anthropics.skills) frontend-design;
      inherit (github.figma.mcp-server-guide) figma-use;
      inherit (github.cocoon-ai.architecture-diagram-generator) architecture-diagram;
      inherit (github.johnlindquist.claude-workshop-skills) chrome-devtools;
      inherit (github.lottiefiles.motion-design-skill) motion-design;
      inherit (github.remotion-dev.skills)
        remotion-best-practices
        remotion-create
        remotion-docs
        remotion-render
        ;
      inherit (github.wordpress.agent-skills)
        wordpress-router
        wp-abilities-api
        wp-block-development
        wp-block-themes
        wp-interactivity-api
        wp-performance
        wp-phpstan
        wp-playground
        wp-plugin-development
        wp-project-triage
        wp-rest-api
        wp-wpcli-and-ops
        wpds
        ;
      inherit (github.greensock.gsap-skills)
        gsap-core
        gsap-frameworks
        gsap-performance
        gsap-plugins
        gsap-react
        gsap-scrolltrigger
        gsap-timeline
        gsap-utils
        ;
      inherit (github.ibelick.ui-skills)
        baseline-ui
        fixing-accessibility
        fixing-metadata
        fixing-motion-performance
        ;
      inherit (github.resend.email-best-practices) email-best-practices;
      inherit (github.cloudflare.skills)
        agents-sdk
        basin
        cf-cli
        cloudflare
        cloudflare-email-service
        cloudflare-one
        cloudflare-one-migrations
        durable-objects
        gateway-workers
        k2
        nextjs-on-cloudflare
        sandbox-migrate-to-next
        sandbox-next
        sandbox-stable
        turnstile-spin
        web-perf
        workers-best-practices
        workers-profiling
        wrangler
        ;
      inherit (github.cloudflare.security-audit-skill) security-audit;
      inherit (github.masup9.a11y-specialist-skills)
        auditing-wcag
        planning-a11y-improvement
        planning-wcag-audit
        reviewing-a11y
        ;
      inherit (github.kepano.obsidian-skills)
        defuddle
        json-canvas
        obsidian-bases
        obsidian-cli
        obsidian-markdown
        ;
      inherit (github.nulab.bee) using-bee backlog-notation;
      inherit (github.mattpocock.skills)
        domain-modeling
        grill-me
        grill-with-docs
        grilling
        ;
      inherit (github.googlechrome.modern-web-guidance) modern-web-guidance chrome-extensions;
      inherit (github.modem-dev.hunk) hunk-review;
      inherit (github.yusukebe.ax) ax;
      inherit (github.github.gh-stack) gh-stack;
      inherit (github.nanaism.yomiyasu) yomiyasu;
      inherit (github.sanity-io.agent-toolkit) sanity-best-practices sanity-migration;
      inherit (github.emilkowalski.skills)
        emil-design-eng
        animate
        animate-expo
        review-animations
        improve-animations
        find-animation-opportunities
        remove-animations
        animation-performance
        animation-vocabulary
        apple-design
        write-swift
        pick-ui-library
        prototype
        mobile-native
        break-ui
        ask-sonner
        ;
    }
    // fromRepo inputs.h-ymt-skills [
      "clean-my-mac"
      "doc-to-excalidraw"
      "empirical-prompt-tuning"
      "figma-bridge"
      "figma-rule"
      "github-pr-review-operation"
      "h10o-figma-tidy-layers"
      "h10o-figma-to-code"
      "h10o-review"
      "image-optimize"
      "japanese-tech-writing"
      "lighthouse-perf-report"
      "linearis"
      "xserver"
    ]
    // fromRepo inputs.glanz-skills [ "ftp-deploy-workflow" ];
in
{
  home.file = lib.mapAttrs' (
    name: src: lib.nameValuePair ".claude/skills/${name}" { source = src; }
  ) skills;
}
