export interface BackendLocation {
  id: number;
  city?: string | null;
  region?: string | null;
}

export interface BackendOpportunityItem {
  id: number;
  title: string;
  category?: string | null;
  deadline?: string | null; // ISO date
  locations?: BackendLocation[];
}

export interface PagedResponse<T> {
  total: number;
  page: number;
  page_size: number;
  items: T[];
}

const BASE_URL = (import.meta as any).env?.VITE_API_URL || 'http://127.0.0.1:8000';

export async function fetchOpportunitiesPaged(params?: {
  page?: number;
  page_size?: number;
  query?: string;
  category?: string;
  region?: string;
  city?: string;
  modality?: string;
}): Promise<PagedResponse<BackendOpportunityItem>> {
  const url = new URL(BASE_URL + '/opportunities/paged');
  const q = {
    page: String(params?.page ?? 1),
    page_size: String(params?.page_size ?? 10),
    query: params?.query ?? '',
    category: params?.category ?? '',
    region: params?.region ?? '',
    city: params?.city ?? '',
    modality: params?.modality ?? '',
  } as Record<string, string>;

  Object.entries(q).forEach(([k, v]) => {
    if (v) url.searchParams.set(k, v);
  });

  const res = await fetch(url.toString());
  if (!res.ok) {
    throw new Error('Failed to load opportunities: ' + res.status);
  }
  return res.json();
}


