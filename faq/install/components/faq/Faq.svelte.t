---
to: src/lib/components/faq/Faq.svelte
---
<script lang="ts">
	import { ChevronDown, ChevronUp } from 'lucide-svelte';
	import { LL } from '$lib/helpers/i18n';
	import { getSiteConfig } from '$lib/helpers/siteConfig';

	const unwrap = (v: unknown) =>
		typeof v === 'function' ? (v as () => string)() : (v as string);

	type FaqItemT = {
		question: string | (() => string);
		answer: string | (() => string);
	};

	type FaqItem = { id: number; question: string; answer: string };

	let openFaqId: number | null = null;
	function toggleFaq(id: number) {
		openFaqId = openFaqId === id ? null : id;
	}

	const __cfg = getSiteConfig();
	const languageEnabled = (__cfg?.language as { enabled?: boolean } | undefined)?.enabled ?? false;
	const configFaq = (__cfg?.modules as { faq?: { heading?: string; faqs?: Array<{ question: string; answer: string }> } } | undefined)?.faq;

	// When language enabled and modules.faq exists: use i18n; else use modules.faq from config
	$: faqs = ((): FaqItem[] => {
		if (languageEnabled && $LL?.modules?.faq?.faqs != null) {
			const fromLl = $LL.modules.faq.faqs as unknown as Record<string, FaqItemT>;
			return Object.values(fromLl).map((item, idx) => ({
				id: idx + 1,
				question: unwrap(item.question),
				answer: unwrap(item.answer)
			}));
		}
		const list = configFaq?.faqs ?? [];
		return list.map((item, idx) => ({
			id: idx + 1,
			question: item.question,
			answer: item.answer
		}));
	})();

	$: heading = ((): string => {
		if (languageEnabled && $LL?.modules?.faq?.heading != null) return unwrap($LL.modules.faq.heading);
		return configFaq?.heading ?? 'FAQ';
	})();
</script>

<section id="faq" class="w-full py-16 md:py-8 lg:py-16">
	<div class="w-full">
		<div class="w-full mx-auto">
			<!-- Heading Section -->
			<div class="mb-6 heading-component w-full flex flex-col items-center">
				<div
					class="text-slate-900 dark:text-white font-bold tracking-tight w-full text-center text-2xl lg:text-3xl xl:text-4xl leading-tight max-xl:text-2xl max-xl:leading-tight max-md:text-xl max-md:leading-tight max-sm:text-xl max-sm:leading-tight"
				>
					{heading}
				</div>
			</div>

			<!-- FAQ Accordion -->
			<div class="max-w-4xl mx-auto">
				<div class="space-y-4">
					{#each faqs as faq}
						<div
							class="bg-white dark:bg-slate-800 rounded-lg border border-slate-200 dark:border-slate-700 shadow-sm"
						>
							<button
								on:click={() => toggleFaq(faq.id)}
								class="w-full px-6 py-4 text-left flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors duration-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 dark:focus:ring-offset-slate-800"
								aria-expanded={openFaqId === faq.id}
								aria-controls={`faq-answer-${faq.id}`}
							>
								<span
									class="text-lg font-semibold text-slate-900 dark:text-white pr-4"
								>
									{faq.question}
								</span>
								<div class="flex-shrink-0">
									{#if openFaqId === faq.id}
										<ChevronUp
											class="w-5 h-5 text-slate-500 dark:text-slate-400"
										/>
									{:else}
										<ChevronDown
											class="w-5 h-5 text-slate-500 dark:text-slate-400"
										/>
									{/if}
								</div>
							</button>

							<div
								id={`faq-answer-${faq.id}`}
								class={`overflow-hidden transition-[max-height] duration-300 ease-in-out ${
									openFaqId === faq.id ? 'max-h-[1000px]' : 'max-h-0'
								}`}
							>
								<div class="px-6 pt-6 pb-4">
									<p class="text-slate-600 dark:text-slate-300 leading-relaxed">
										{faq.answer}
									</p>
								</div>
							</div>
						</div>
					{/each}
				</div>
			</div>
		</div>
	</div>
</section>
