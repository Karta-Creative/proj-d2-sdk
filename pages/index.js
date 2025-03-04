import Link from "@docusaurus/Link"
import useDocusaurusContext from "@docusaurus/useDocusaurusContext"
import useBaseUrl from "@docusaurus/useBaseUrl"
import D2LogoUrl from "@site/static/D2.png"
import Layout from "@theme/Layout"
import clsx from "clsx"
import React from "react"
import styles from "./index.module.css"

function HomepageHeader() {
    const { siteConfig } = useDocusaurusContext()
    return (
        <header className={clsx("hero", styles.heroBanner)}>
            <div className="container">
                <img src={D2LogoUrl} alt="D2 Logo" className={styles.logo} />
                <p className="hero__subtitle">{siteConfig.tagline}</p>
                <div className={styles.buttons}>
                    <Link
                        className="button button--secondary button--lg"
                        to="/docs/integrating-d2-with-your-game"
                    >
                        Integrate D2
                    </Link>

                    <p>
                        <a href={useBaseUrl('/D2.rbxm')} >
                            or just download the module
                        </a>
                    </p>
                </div>
            </div>
        </header>
    )
}

export default function Home() {
    const { tagline } = useDocusaurusContext()
    return (
        <Layout description={tagline}>
            <HomepageHeader />

            <section className="container margin-top--xl">
                <div className="row">
                    <div className="col col--6">
                        <h2>The D2 Mission</h2>
                        <p><strong>Make gamers move.</strong></p>

                        <p>At D2, we believe that moving your body is beneficial. Whether it's running, walking, dancing, swimming, or playing sports—movement improves physical and mental well-being.</p>

                        <p>Building healthy habits requires motivation. As gamers, we understand the power of play and community. Fun gameplay, friendly competition, satisfying progress, thrilling stories, and human connections keep billions of gamers engaged worldwide.</p>

                        <p>We harness that same motivation to encourage gamers to exercise.</p>

                        <hr />

                        <h2>Available now on</h2>
                        <div className={styles.download}>
                            <a href="https://apps.apple.com/us/app/d2-health-club/id6740983037">
                                <img src="/appstore.svg" alt="Download on the App Store" />
                            </a>
                            <a href="https://play.google.com/store/apps/details?id=com.d2.health">
                                <img src="/playstore.svg" alt="Get it on Google Play" />
                            </a>
                        </div>
                    </div>

                </div>
            </section>
        </Layout>
    )
}
